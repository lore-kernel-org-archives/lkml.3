Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751253Ab3JTPWE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 11:22:04 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:60788 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061Ab3JTPWB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 11:22:01 -0400
MIME-Version: 1.0
In-Reply-To: <5263DA0A.7030004@linux.com>
References: <CABjrhvqTHkuEyQ=-xaud5Y0i3YqYcdBsm2eWrR-44V=OESWypg@mail.gmail.com>
	<F713E780-33E1-494C-ADAD-92211724209E@dubeyko.com>
	<CABjrhvqLgVSEOJVuS1n-R_kyvhFouUqhfjqS4P_jsPGAec+KdQ@mail.gmail.com>
	<20131020123521.GA15627@thunk.org>
	<CABjrhvpzcETE=CZrOkRgxpKhFm9-piYJLJ=8zdwnNkmJtkWRtQ@mail.gmail.com>
	<5263D576.70202@linux.com>
	<CABjrhvq8WYUzv6DVewiincNkSH9rCC_-1RVEOop1QE8+e3dnig@mail.gmail.com>
	<5263DA0A.7030004@linux.com>
Date: Sun, 20 Oct 2013 23:22:00 +0800
Message-ID: <CABjrhvomv62ww9z3_LXosWVMPCrAe7jME2NhBa4AkaZP5TQN3Q@mail.gmail.com>
Subject: Re: [RFC] Rollback FS
From: jiaweiwei <jiaweiwei.xiyou@gmail.com>
To: Levente Kurusa <levex@linux.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Vyacheslav Dubeyko <slava@dubeyko.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Harry Wei <harryxiyou@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 20, 2013 at 9:26 PM, Levente Kurusa <levex@linux.com> wrote:
> 2013-10-20 15:19 keltezéssel, jiaweiwei írta:
>> On Sun, Oct 20, 2013 at 9:07 PM, Levente Kurusa <levex@linux.com> wrote:
>> [...]
>>>> A good catch. Following ideas would be suitable.
>>>>
>>>> 1, Keep the blocks or inodes by a parameter we give.
>>>> 2, Keep the blocks or inodes for several seconds.
>>> Keep them where? On the HDD? We just deleted/moved that.
>>
>> Delete/move a file with a parameter, which would keep the blocks or inodes
>> in-place. Or we would keep the blocks or inodes for several seconds.
>
> The problem with keeping the inodes/blocks for several seconds is
> that you would need to find a magic number that is not small enough,
> because if it is, then what if the user doesn't notice the problem
> during a long operation? If the magic number is big, then we waste a
> lot of space.
>
> The problem with the parameter thing is that again, all the different
> filesystems need to support that feature. We can't just tell Ext3 or JFFS2 on the VFS level,
> that 'Hey, keep those inodes in place incase someone just made himself some headache.'
>

Above you said are what we should do. Don't waste time, let me design and
implement it. I would send design document for review, thanks.


-- 
 do kernel
