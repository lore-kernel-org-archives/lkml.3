Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110AbaF2CM1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 22:12:27 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:58632 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbaF2CMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 22:12:25 -0400
Message-ID: <53AF7601.5000205@infradead.org>
Date: Sat, 28 Jun 2014 19:12:17 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Pavel Machek <pavel@ucw.cz>,
        Valdis Kletnieks <valdis.kletnieks@vt.edu>
CC: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        Sonal Santan <sonal.santan@gmail.com>
Subject: Re: [PATCH v2] Documentation: Rename hpfall.c => freefall.c, fixes
 for Dell
References: <1399114077-19314-3-git-send-email-pali.rohar@gmail.com> <1402473727-5464-1-git-send-email-pali.rohar@gmail.com>
In-Reply-To: <1402473727-5464-1-git-send-email-pali.rohar@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This should really be done as 2 separate patches:
One to move/rename the file and one to make the changes/additions
to it for DELL.

Can you resend it as 2 patches like that, please?

Thanks... and sorry for the delay.


On 06/11/14 01:02, Pali Rohár wrote:
> Dell kernel driver dell-smo8800 provides same freefall interface as hp_accel so
> program hpfall.c works also on Dell laptops. So rename it to freefall.c.
> 
> Dell driver does not provide hp::hddprotect led so make sure that freefall.c
> works also if hp::hddprotect does not exist in sysfs.
> 
> Additionally write info to syslog.
> 
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> Cc: Sonal Santan <sonal.santan@gmail.com>
> ---
> Changes since v1:
> * Fixed warnings: Missing a blank line after declarations
> ---
>  Documentation/laptops/00-INDEX   |    4 +-
>  Documentation/laptops/freefall.c |  177 ++++++++++++++++++++++++++++++++++++++
>  Documentation/laptops/hpfall.c   |  146 -------------------------------
>  3 files changed, 179 insertions(+), 148 deletions(-)
>  create mode 100644 Documentation/laptops/freefall.c
>  delete mode 100644 Documentation/laptops/hpfall.c


-- 
~Randy
