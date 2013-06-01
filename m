Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658Ab3FAU5R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 16:57:17 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:59693 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530Ab3FAU5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 16:57:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH 15/15] OF: remove #ifdef from linux/of_platform.h
Date: Sat, 1 Jun 2013 22:57:02 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>, patches@lists.linaro.org,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <1370038972-2318779-1-git-send-email-arnd@arndb.de> <201306012203.39133.arnd@arndb.de> <51AA59D0.7020805@gmail.com>
In-Reply-To: <51AA59D0.7020805@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306012257.02327.arnd@arndb.de>
X-Provags-ID: V02:K0:AMDm9ZfDZ9br7X1mrkqzNailbvEQPin1RrGRKfH/qRc
 vcJuE47z/Zd+1MFCc3kkJtubFQaATyswxd5Vtw+HYvJi4sfV4b
 MTPWuNAqVrL8do1a7T+tVehGIT9XkwuNWXAOKiYTQsagz2WbQH
 TiAo8NnqgrTT6B/4Fs3xVlvnafUzc1dYfkCW28H5RAZUiZebF/
 +0AJ8vE7D21dZu3igPQ8Hf4CToh4+azk+UXDDEtQ1nuvIc+FXU
 mt4/rcu9aRfd3tM1Yc0hJNT8sdu4CVOY9HyxJjJb/0NkYkGCWO
 Bvg9FyM3uL3f6+29E7aiv2z+gPjWqsTUvUQ/Wk/VCwFfeicc/+
 jKej35V0Hvw9gpWR7K3w=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 01 June 2013, Rob Herring wrote:
> No, we still need empty functions. Here is what of_device.h looks like:
> 
> http://tinyurl.com/l2azz5m
> 
> BTW, it has your ack.
> 

Could you add a patch on top that only puts the function declarations
inside of #ifdef that don't have an inline wrapper?

It's really annoying to have to change the header file every time one
needs to call a function from a driver in the DT-only case.

	Arnd
