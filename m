Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751253Ab3JTNHI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 09:07:08 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:35319 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab3JTNHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 09:07:06 -0400
Message-ID: <5263D576.70202@linux.com>
Date: Sun, 20 Oct 2013 15:07:02 +0200
From: Levente Kurusa <levex@linux.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: jiaweiwei <jiaweiwei.xiyou@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Vyacheslav Dubeyko <slava@dubeyko.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Harry Wei <harryxiyou@gmail.com>
Subject: Re: [RFC] Rollback FS
References: <CABjrhvqTHkuEyQ=-xaud5Y0i3YqYcdBsm2eWrR-44V=OESWypg@mail.gmail.com>	<F713E780-33E1-494C-ADAD-92211724209E@dubeyko.com>	<CABjrhvqLgVSEOJVuS1n-R_kyvhFouUqhfjqS4P_jsPGAec+KdQ@mail.gmail.com>	<20131020123521.GA15627@thunk.org> <CABjrhvpzcETE=CZrOkRgxpKhFm9-piYJLJ=8zdwnNkmJtkWRtQ@mail.gmail.com>
In-Reply-To: <CABjrhvpzcETE=CZrOkRgxpKhFm9-piYJLJ=8zdwnNkmJtkWRtQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013-10-20 14:59 keltezéssel, jiaweiwei írta:
> On Sun, Oct 20, 2013 at 8:35 PM, Theodore Ts'o <tytso@mit.edu> wrote:
>> On Sun, Oct 20, 2013 at 07:37:01PM +0800, jiaweiwei wrote:
>>>
>>> Any file system should rollback but not specific ones. Therefore, a
>>> VFS like mechanism should be designed and implemented.
>>
>> And what if the blocks or inodes used for the files that were deleted
>> have already been used and overwritten?
> 
> A good catch. Following ideas would be suitable.
> 
> 1, Keep the blocks or inodes by a parameter we give.
> 2, Keep the blocks or inodes for several seconds.
Keep them where? On the HDD? We just deleted/moved that.
In memory? How about a 4+ GB file(s)?
> 
>>
>>> Maybe, I would give detail design, thanks.
>>
>> I encourage you to try to do that; you might find it to be an
>> educational exercise.
>>
> 
> Yeah, I would, thanks.
> 
> 

I think he meant to be ironic.

-- 
Regards,
Levente Kurusa
