Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832Ab3A2S4M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 13:56:12 -0500
Received: from mail.skyhub.de ([78.46.96.112]:42612 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753485Ab3A2S4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 13:56:10 -0500
Date: Tue, 29 Jan 2013 19:56:07 +0100
From: Borislav Petkov <bp@alien8.de>
To: Simon Que <sque@chromium.org>
Cc: linux-kernel@vger.kernel.org, Mandeep Singh Baines <msb@chromium.org>
Subject: Re: [PATCH] Add -Werror build option
Message-ID: <20130129185607.GF14444@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Simon Que <sque@chromium.org>, linux-kernel@vger.kernel.org,
	Mandeep Singh Baines <msb@chromium.org>
References: <1359485478-23639-1-git-send-email-sque@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1359485478-23639-1-git-send-email-sque@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2013 at 10:51:18AM -0800, Simon Que wrote:
> Add a config option "ERROR_ON_WARNING" that adds the "-Werror" flag to
> gcc, which turns warnings into errors.
> 
> This option enables developers to set a stricter level of code checking
> for kernel code: all code must be warning-free.

And we want this because...?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
