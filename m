Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965350Ab3BMXWi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 18:22:38 -0500
Received: from mail.skyhub.de ([78.46.96.112]:33179 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965136Ab3BMXWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 18:22:37 -0500
Date: Thu, 14 Feb 2013 00:22:28 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Scan Subscription <scan-subscription@coverity.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: New Defect(s) reported by Coverity Scan
Message-ID: <20130213232228.GF18013@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Scan Subscription <scan-subscription@coverity.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	David Woodhouse <dwmw2@infradead.org>
References: <C0A4ACBB26D853488EA0C68388B70268172CCF11@BLUPRD0512MB628.namprd05.prod.outlook.com>
 <20130213183842.GC26948@pd.tnic>
 <C0A4ACBB26D853488EA0C68388B70268172CD159@BLUPRD0512MB628.namprd05.prod.outlook.com>
 <20130213191352.GC18013@pd.tnic>
 <511C1E8E.5040106@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <511C1E8E.5040106@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 03:15:26PM -0800, H. Peter Anvin wrote:
> Not really, since exit() does that.  We might want it for clarity's
> sake, though.

Well, I would add a comment only then and teach the tool when parsing
exit() to know that - no need for fixing perfectly good code only for a
tool's sake.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
