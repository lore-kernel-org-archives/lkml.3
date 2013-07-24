Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744Ab3GXGKy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 02:10:54 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:50450 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865Ab3GXGKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 02:10:53 -0400
MIME-Version: 1.0
In-Reply-To: <20130723203543.GA24844@kroah.com>
References: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
 <1374509230-3324-22-git-send-email-bergwolf@gmail.com> <20130723203543.GA24844@kroah.com>
From: Peng Tao <bergwolf@gmail.com>
Date: Wed, 24 Jul 2013 14:10:31 +0800
Message-ID: <CA+a=Yy4n6-ABEr8i278Cq4N_9-5UoHSXLdSo5_z0cO10ALrCxA@mail.gmail.com>
Subject: Re: [PATCH 21/48] staging/lustre/obdclass: use a dummy structure for lu_ref_link
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "John L. Hammond" <john.hammond@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 4:35 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Tue, Jul 23, 2013 at 12:06:42AM +0800, Peng Tao wrote:
>> From: "John L. Hammond" <john.hammond@intel.com>
>>
>> Move the definition of struct lu_ref_link to lu_ref.h.  If USE_LU_REF
>> is not defined then define it to be the empty struct.  Change the
>> return type of lu_ref_add() and lu_ref_add_atomic() to void.  Add
>> lu_ref_add_at() taking same arguments as lu_ref_add() togerther with a
>> pointer to a struct lu_ref_link and returning void.  Adjust all
>> structures containing a lu_ref_link pointer to contain a struct
>> lu_ref_link instead.  Use lu_ref_add_at() and lu_ref_del_at() to
>> handle embedded lu_ref_links.
>>
>> Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3059
>> Lustre-change: http://review.whamcloud.com/5920
>> Signed-off-by: John L. Hammond <john.hammond@intel.com>
>> Reviewed-by: Alex Zhuravlev <alexey.zhuravlev@intel.com>
>> Reviewed-by: Jinshan Xiong <jinshan.xiong@intel.com>
>> Reviewed-by: Mike Pershin <mike.pershin@intel.com>
>> Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
>> Signed-off-by: Peng Tao <tao.peng@emc.com>
>> Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
>
> This patch fails to apply :(
>
It relies on one previous patch ([PATCH 02/48]
staging/lustre/obdclass: restore lu_ref), which you have suggested to
drop. I will remove unnecessary part of the patch and resend (if
there's still anything left).

Thanks,
Tao
