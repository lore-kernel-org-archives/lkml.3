Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965230Ab3BMXQH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 18:16:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45874 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761077Ab3BMXQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 18:16:05 -0500
Message-ID: <511C1E8E.5040106@zytor.com>
Date: Wed, 13 Feb 2013 15:15:26 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>,
        Scan Subscription <scan-subscription@coverity.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: New Defect(s) reported by Coverity Scan
References: <C0A4ACBB26D853488EA0C68388B70268172CCF11@BLUPRD0512MB628.namprd05.prod.outlook.com> <20130213183842.GC26948@pd.tnic> <C0A4ACBB26D853488EA0C68388B70268172CD159@BLUPRD0512MB628.namprd05.prod.outlook.com> <20130213191352.GC18013@pd.tnic>
In-Reply-To: <20130213191352.GC18013@pd.tnic>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2013 11:13 AM, Borislav Petkov wrote:
> 
> and it might really need fclose() there for correctness' sake.
> 

Not really, since exit() does that.  We might want it for clarity's
sake, though.

	-hpa

