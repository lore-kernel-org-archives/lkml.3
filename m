Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772Ab3A2EkX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 23:40:23 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:44092 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159Ab3A2EkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 23:40:17 -0500
Date: Tue, 29 Jan 2013 04:40:13 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH 0/2] Secure Boot: More controversial changes
Message-ID: <20130129044013.GC14395@srcf.ucam.org>
References: <1359391662-26120-1-git-send-email-matthew.garrett@nebula.com>
 <51072E84.4080509@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51072E84.4080509@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 06:05:56PM -0800, H. Peter Anvin wrote:
> These at the very least need some kind of CONFIG_WEAK_SECURE_BOOT
> option or something like that.

Given Eric's views on the kexec patch (and given that there's no point 
in the hibernate one if kexec's available...), I'm not planning on 
pushing these until there's a plausible story for limiting kexec to 
signed images.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
