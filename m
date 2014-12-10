Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821AbaLJC4r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 21:56:47 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:54376 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651AbaLJC4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 21:56:45 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1412080738210.2100@localhost6.localdomain6>
References: <1417980062-25151-1-git-send-email-Julia.Lawall@lip6.fr>
 <CAGRGNgWDJqV=XD+6q26Ma=m1sEi1kvLWsjq6=RjRVSFTxow0Qg@mail.gmail.com> <alpine.DEB.2.02.1412080738210.2100@localhost6.localdomain6>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 10 Dec 2014 13:56:23 +1100
Message-ID: <CAGRGNgVGEo8qqpjDvYOJRBtEjXsKmFtXSQrS_Q+tDEYS+nAQqA@mail.gmail.com>
Subject: Re: [PATCH 0/20] fix misspelling of current function in string
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, linux@rasmusvillemoes.dk,
        Joe Perches <joe@perches.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        linux-mtd@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        "Mailing List, Arm" <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-pci@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        linux-usb@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Julia,

On Mon, Dec 8, 2014 at 5:43 PM, Julia Lawall <julia.lawall@lip6.fr> wrote:
> On Mon, 8 Dec 2014, Julian Calaby wrote:
>
>> Hi Julia,
>>
>> On Mon, Dec 8, 2014 at 6:20 AM, Julia Lawall <Julia.Lawall@lip6.fr> wrote:
>> > These patches replace what appears to be a reference to the name of the
>> > current function but is misspelled in some way by either the name of the
>> > function itself, or by %s and then __func__ in an argument list.
>>
>> Would there be any value in doing this for _all_ cases where the
>> function name is written in a format string?
>
> Probably.  But there are a lot of them.  Even for the misspellings, I have
> only don about 1/3 of the cases.
>
> On the other hand, the misspelling have to be checked carefully, because a
> misspelling of one thing could be the correct spelling of the thing thst
> was actually intended.
>
> Joe, however, points out that a lot of these prints are just for function
> tracing, and could be removed.  I worked on another semantic patch that
> tries to do that.  It might be better to remove those prints completely,
> rather than sending one patch to transform them and then one patch to
> remove them after that.  That is why for this series I did only the ones
> where there was actually a problem.

Ok, that makes sense.

Either way though, this is a really interesting application of the
semantic patching. Nice work!

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
