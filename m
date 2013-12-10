Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948Ab3LJXjZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 18:39:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54078 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924Ab3LJXjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 18:39:23 -0500
Message-ID: <52A7A5D9.9030504@zytor.com>
Date: Tue, 10 Dec 2013 15:38:01 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Andrew Morton <akpm@linux-foundation.org>
CC: Dave Young <dyoung@redhat.com>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        greg@kroah.com, matt@console-pimps.org, toshi.kani@hp.com
Subject: Re: [PATCH v5 00/14] kexec kernel efi runtime support
References: <1386582147-9802-1-git-send-email-dyoung@redhat.com> <20131210152549.7975e3ac25d854e2ada63221@linux-foundation.org> <20131210233207.GI31437@pd.tnic>
In-Reply-To: <20131210233207.GI31437@pd.tnic>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2013 03:32 PM, Borislav Petkov wrote:
> On Tue, Dec 10, 2013 at 03:25:49PM -0800, Andrew Morton wrote:
>> On Mon,  9 Dec 2013 17:42:13 +0800 Dave Young <dyoung@redhat.com> wrote:
>>
>>> Here is the V5 patchset for supporting kexec kernel efi runtime.
>>
>> It's unclear (to me) who's supposed to merge this lot.  It's a "kexec"
>> patch which actually hits on efi and x86.
>>
>> I grabbed them for some -next testing but won't be offended if someone
>> else merges them ;)
> 
> I was under the impression that this should go through Matt's efi tree.
> Oh, and we need to finish reviewing them so picking them up now would be
> too premature, IMHO.
> 

My intent was to pick them into a separate branch of the tip tree either
directly or via Matt (since Matt feeds us anyway.)

But yes, work is still underway, although it is getting there.

	-hpa

