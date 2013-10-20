Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751227Ab3JTNTh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 09:19:37 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:39917 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066Ab3JTNTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 09:19:36 -0400
MIME-Version: 1.0
In-Reply-To: <5263D576.70202@linux.com>
References: <CABjrhvqTHkuEyQ=-xaud5Y0i3YqYcdBsm2eWrR-44V=OESWypg@mail.gmail.com>
	<F713E780-33E1-494C-ADAD-92211724209E@dubeyko.com>
	<CABjrhvqLgVSEOJVuS1n-R_kyvhFouUqhfjqS4P_jsPGAec+KdQ@mail.gmail.com>
	<20131020123521.GA15627@thunk.org>
	<CABjrhvpzcETE=CZrOkRgxpKhFm9-piYJLJ=8zdwnNkmJtkWRtQ@mail.gmail.com>
	<5263D576.70202@linux.com>
Date: Sun, 20 Oct 2013 21:19:34 +0800
Message-ID: <CABjrhvq8WYUzv6DVewiincNkSH9rCC_-1RVEOop1QE8+e3dnig@mail.gmail.com>
Subject: Re: [RFC] Rollback FS
From: jiaweiwei <jiaweiwei.xiyou@gmail.com>
To: Levente Kurusa <levex@linux.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Vyacheslav Dubeyko <slava@dubeyko.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Harry Wei <harryxiyou@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 20, 2013 at 9:07 PM, Levente Kurusa <levex@linux.com> wrote:
[...]
>> A good catch. Following ideas would be suitable.
>>
>> 1, Keep the blocks or inodes by a parameter we give.
>> 2, Keep the blocks or inodes for several seconds.
> Keep them where? On the HDD? We just deleted/moved that.

Delete/move a file with a parameter, which would keep the blocks or inodes
in-place. Or we would keep the blocks or inodes for several seconds.




-- 
 do kernel
