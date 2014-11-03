Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584AbaKCKQO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 05:16:14 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:40407 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751016AbaKCKQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 05:16:10 -0500
X-Sasl-enc: PjKBxARLy26ep0238c+M7X6rIHo7j6HVU9I9Xc+Ka4uW 1415009769
Date: Mon, 3 Nov 2014 08:15:58 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Kweh Hock Leong <hock.leong.kweh@intel.com>
Cc: Matt Fleming <matt.fleming@intel.com>, Ming Lei <ming.lei@canonical.com>,
        Sam Protsenko <semen.protsenko@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-efi@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: Re: [PATCH v2 1/3] firmware loader: Introduce new API -
 request_firmware_abort()
Message-ID: <20141103101558.GA11739@khazad-dum.debian.net>
References: <1414984030-13859-1-git-send-email-hock.leong.kweh@intel.com>
 <1414984030-13859-2-git-send-email-hock.leong.kweh@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414984030-13859-2-git-send-email-hock.leong.kweh@intel.com>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 Nov 2014, Kweh Hock Leong wrote:
> Note for people who use request_firmware_nowait():
> You are required to do your own synchronization after you call
> request_firmware_abort() in order to continue unloading the
> module. The example synchronization code shows below:
> 
> while (THIS_MODULE && module_refcount(THIS_MODULE))
> 	msleep(20);

This is _so_ asking for people to get it wrong, it is not funny :-(

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
