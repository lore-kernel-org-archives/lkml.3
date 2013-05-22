Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab3EVGAk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 02:00:40 -0400
Received: from relay.parallels.com ([195.214.232.42]:50156 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab3EVGAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 02:00:39 -0400
Message-ID: <519C5EF1.9040802@parallels.com>
Date: Wed, 22 May 2013 10:00:17 +0400
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: "J. Bruce Fields" <bfields@fieldses.org>, <akpm@linux-foundation.org>,
        <jlayton@redhat.com>, <lucas.demarchi@profusion.mobi>,
        <rusty@rustcorp.com.au>, <linux-kernel@vger.kernel.org>,
        <viro@zeniv.linux.org.uk>, <bharrosh@panasas.com>, <devel@openvz.org>
Subject: Re: [RFC PATCH] kmod: add ability to swap root in usermode helper
References: <20130520070017.7957.9224.stgit@localhost.localdomain> <20130520135716.GA10084@redhat.com> <519A3693.8020006@parallels.com> <20130520151001.GA13173@redhat.com> <20130520212412.GI14677@fieldses.org> <20130521152836.GA13461@redhat.com> <20130521153531.GO14677@fieldses.org> <20130521162925.GA19785@redhat.com>
In-Reply-To: <20130521162925.GA19785@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.18.163]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

21.05.2013 20:29, Oleg Nesterov пишет:
> On 05/21, J. Bruce Fields wrote:
>>
>> On Tue, May 21, 2013 at 05:28:36PM +0200, Oleg Nesterov wrote:
>>>
>>> OK, so do not do this. Export the new helper.
>>
>> You mean, export umh_set_fs_root() in the above?
>>
>> That might be OK.
>
> Yes, or even call_usermodehelper_root().
>
> I didn't argue with the new helper that, yes, has the additional
> argument. Although personally I think it would be better to not
> add it into kmod.c (until it has more users), but I am not sure
> there is a better place somewhere in nfs code. Whatever is more
> convenient for you.
>
> To me this looks like call_usermodehelper_keys().
>
> Oleg.
>

Thanks, Oleg. Sounds reasonable.

-- 
Best regards,
Stanislav Kinsbursky
