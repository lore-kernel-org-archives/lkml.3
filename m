Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752292AbaIMVNK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 17:13:10 -0400
Received: from mout.gmx.net ([212.227.17.22]:58836 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137AbaIMVNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 17:13:06 -0400
From: Peter =?iso-8859-15?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm: merge duplicate transmit_cmd() functions
Date: Sat, 13 Sep 2014 23:13:53 +0200
User-Agent: KMail/1.13.7 (Linux/3.16.2-dirty; KDE/4.12.5; x86_64; ; )
Cc: tpmdd-devel@lists.sourceforge.net, Marcel Selhorst <tpmdd@selhorst.net>,
        linux-kernel@vger.kernel.org, jgunthorpe@obsidianresearch.com
References: <1410629733-10105-1-git-send-email-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <1410629733-10105-1-git-send-email-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201409132313.53402.PeterHuewe@gmx.de>
X-Provags-ID: V03:K0:NzL1iFeKsIlfGKv/622J9s9AcJvQEmRm5vi3rwBaKKuntbHgBEr
 AuCWoG5ArU+KbcE2i7ovi6lmSpN7VjdcoMZIXG7ixgRhjDC/MlQDxGWWg9CWjHueXpDfEcn
 glfJSrZKD/Am18VOIkrzGssA1096lN5WF+VqCpGNjgV7bl4npQnqlpDp7Q7ILunxOuwSJlr
 v7z37Tj8TwlAanD1l+AQA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi


Am Samstag, 13. September 2014, 19:35:33 schrieb Jarkko Sakkinen:
> Replaced transmit_cmd() functions in tpm-interface.c and tpm-sysfs.c
> with a single tpm_transmit_cmd() that can be used in both files.
> 
> This patch is preliminary clean up work for the TPM2 support. This
> function is needed for implementing TPM2 versions of the in-kernel
> TPM utility functions.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

why the renaming?


> 
>  ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
>  		     size_t bufsiz);
Can this be removed then?

> +ssize_t tpm_transmit_cmd(struct tpm_chip *chip, struct tpm_cmd_t *cmd,
> +			 int len, const char *desc);
>  extern int tpm_get_timeouts(struct tpm_chip *);
>  extern void tpm_gen_interrupt(struct tpm_chip *);
>  extern int tpm_do_selftest(struct tpm_chip *);



Peter
