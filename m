Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675Ab3DLO5b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 10:57:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56285 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752989Ab3DLO53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 10:57:29 -0400
Message-ID: <5168208B.7050107@zytor.com>
Date: Fri, 12 Apr 2013 07:56:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Yinghai Lu <yinghai@kernel.org>, Thomas Renninger <trenn@suse.de>,
        Simon Horman <horms@verge.net.au>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Cliff Wickman <cpw@sgi.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Hansen <dave@sr71.net>
Subject: Re: [PATCH 5/5] kexec: X86: Pass memory ranges via e820 table instead
 of memmap= boot parameter
References: <1365683207-42425-1-git-send-email-trenn@suse.de> <1365683207-42425-6-git-send-email-trenn@suse.de> <CAE9FiQXnZzVC7dtvXWrqz=jYAGH053R8Vw1qkrMd2F+hAaMxdQ@mail.gmail.com> <5166D18A.7090800@zytor.com> <20130412143104.GA4301@redhat.com>
In-Reply-To: <20130412143104.GA4301@redhat.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2013 07:31 AM, Vivek Goyal wrote:
>>
>> I also have to admit that I don't see the difference between /dev/mem
>> and /dev/oldmem, as the former allows access to memory ranges outside
>> the ones used by the current kernel, which is what the oldmem device
>> seems to be intended to od.
> 
> I think one difference seems to be that /dev/mem assumes that validly
> accessed memory is already mapped in kernel while /dev/oldmeme assumes
> it is not mapped and creates temporary mappings explicitly.
> 

Dave Hansen has been working on fixing /dev/mem for HIGHMEM.

	-hpa


