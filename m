Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965339Ab3BMXZc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 18:25:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45963 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462Ab3BMXZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 18:25:31 -0500
Message-ID: <511C2098.3050303@zytor.com>
Date: Wed, 13 Feb 2013 15:24:08 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>,
        Scan Subscription <scan-subscription@coverity.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: New Defect(s) reported by Coverity Scan
References: <C0A4ACBB26D853488EA0C68388B70268172CCF11@BLUPRD0512MB628.namprd05.prod.outlook.com> <20130213183842.GC26948@pd.tnic> <C0A4ACBB26D853488EA0C68388B70268172CD159@BLUPRD0512MB628.namprd05.prod.outlook.com> <20130213191352.GC18013@pd.tnic> <511C1E8E.5040106@zytor.com> <20130213232228.GF18013@pd.tnic>
In-Reply-To: <20130213232228.GF18013@pd.tnic>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2013 03:22 PM, Borislav Petkov wrote:
> On Wed, Feb 13, 2013 at 03:15:26PM -0800, H. Peter Anvin wrote:
>> Not really, since exit() does that.  We might want it for clarity's
>> sake, though.
> 
> Well, I would add a comment only then and teach the tool when parsing
> exit() to know that - no need for fixing perfectly good code only for a
> tool's sake.
> 

No, but clarity is good.  It isn't just the tool that might get annoyed.

	-hpa

