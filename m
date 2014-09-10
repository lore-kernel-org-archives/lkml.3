Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751775AbaIJPEo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 11:04:44 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:35400 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbaIJPEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 11:04:42 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-a3-541068867cae
Message-id: <541066FB.9070606@samsung.com>
Date: Wed, 10 Sep 2014 18:58:03 +0400
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.7.0
MIME-version: 1.0
To: Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org
Cc: Dmitry Vyukov <dvyukov@google.com>, Konstantin Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Michal Marek <mmarek@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Vegard Nossum <vegard.nossum@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kbuild@vger.kernel.org,
        x86@kernel.org, linux-mm@kvack.org,
        Randy Dunlap <rdunlap@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [RFC/PATCH v2 00/10] Kernel address sainitzer (KASan) - dynamic
 memory error deetector.
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1410359487-31938-1-git-send-email-a.ryabinin@samsung.com>
 <541067D1.4090907@intel.com>
In-reply-to: <541067D1.4090907@intel.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02SfSzUcRzH9/09nsvl6yLfaWXZtJiHjLVvZaY/4jdltcXWrK0O153NobtY
	eprIxXFmzNPN0K4a5xbOmofJU+aKEvKwhKiIcowztIvq+Md/r33er/fn88+HRwpHKGdebPwt
	sTxeFOfK8Km+beOwl1IKw0/U5BzGllelNC6r1TO4e3SDxcvPcwAeW18EeHVhGuAfMzMszptR
	srio3glXZ6czuHHORODqrGka/2lpIvDHljIGT+n/0nioo5LAj9oGCKw0b9PYqO4gsGmimMLK
	p/UE1nZ/JvHSXAGJGwyFJB7RdbL4w5aRxpt13+igQ5y+XA+4iuYVwDVrJlmu0pDENVR5cNrW
	BYIz6LIYzrCaz3Iq0zDBLfX3s9ybEgvFfR8uJriV2XGKW24bYbh3ld0sZzYcuSSM5AfEiONi
	k8Vyn8DrfOla9jJILCdur//MB6ngK1ABHg9BfzScJlEBm/94EA1M1TIqwOcJ4TOAdBm5wBoI
	YTqB1L/8rL4AeiBTY5h1TEE3VNtZuKMw0BttaxoZKzvCK+i3eZ21sgDao82CKcrKDvAcqsrO
	oKz7SahhUV99/U7hALyBlL3z9O7hJwANVehoa2AD3dFWXetOm4SeqD2jiNllF9SgN5F5AGr2
	HNHs0TR7tEpA6oCjOCk6URElkfl6K0QyRVK8xDs6QWYAu6+w1gS0Pae7AOQBV1vBzUG7cCEt
	SlakyLoA4pGuDoK0IBguFMSIUu6I5QnX5ElxYkUXIHg2zqmA/9bFfzri8mjI47vtjfd6Fjxb
	O5rd6OMDtlJnR0nbuPF9bwAkTz7s/VL6uujU1TQnn6iLIaGDR+3U81kFhcHnxRHlD15MBJ5V
	5/oFj9num7mQekwTnBlhMWbSkQJBSf+nSXOo130z5p9ZrHHYeJk/KLQ37XcHs71hSxZPLz/t
	vCulkIp8PUi5QvQPWKMvHugCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2014 07:01 PM, Dave Hansen wrote:
> On 09/10/2014 07:31 AM, Andrey Ryabinin wrote:
>> This is a second iteration of kerenel address sanitizer (KASan).
> 
> Could you give a summary of what you've changed since the last version?
> 

I gave, grep for "Changes since v1:"
