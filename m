Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289AbaIWQpz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 12:45:55 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:60286 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932119AbaIWQpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 12:45:54 -0400
Message-ID: <1411490752.20236.28.camel@x220>
Subject: Re: [PATCH v4] checkkconfigsymbols.sh: reimplementation in python
From: Paul Bolle <pebolle@tiscali.nl>
To: Valentin Rothberg <valentinrothberg@gmail.com>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        stefan.hengelein@fau.de
Date: Tue, 23 Sep 2014 18:45:52 +0200
In-Reply-To: <1411397898-13797-1-git-send-email-valentinrothberg@gmail.com>
References: <1411222524-7850-1-git-send-email-valentinrothberg@gmail.com>
	 <1411397898-13797-1-git-send-email-valentinrothberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Sep 2014 16:45:52.0449 (UTC) FILETIME=[D6476310:01CFD74D]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Valentin,

On Mon, 2014-09-22 at 16:58 +0200, Valentin Rothberg wrote:
> +FEATURE = r"\w*[A-Z]{1}\w*"
> +CONFIG_DEF = r"^\s*(?:menu){,1}config\s+(" + FEATURE + r")\s*"

If I read this correctly, this misidentifies these Kconfig symbols (all
found in powerpc, by the way):
    8260
    8272
    40x
    44x
    6xx
    8xx
    4xx

8260 and 8272 are rather unfortunate names. I'm all for renaming them.
But we're probably stuck with those other five symbols.


Paul Bolle

