Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647AbaEaVVm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 17:21:42 -0400
Received: from mail-qg0-f54.google.com ([209.85.192.54]:35296 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbaEaVVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 17:21:40 -0400
MIME-Version: 1.0
In-Reply-To: <538A46DF.1040009@cogentembedded.com>
References: <1401542051-3174-1-git-send-email-peter.senna@gmail.com>
	<538A46DF.1040009@cogentembedded.com>
Date: Sat, 31 May 2014 18:21:39 -0300
Message-ID: <CA+MoWDqDqwOSirh+aP72t_t_2KNajmfn8v5ywpAuLsjJssBwxw@mail.gmail.com>
Subject: Re: [PATCH 1/11] USB: kl5kusb105: Remove useless return variables
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Oliver Neukum <oliver@neukum.org>, kernel-janitors@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 31, 2014 at 6:17 PM, Sergei Shtylyov
<sergei.shtylyov@cogentembedded.com> wrote:
> Hello.
>
>
> On 05/31/2014 05:14 PM, Peter Senna Tschudin wrote:
>
>> This patch remove variables that are initialized with a constant,
>> are never updated, and are only used as parameter of return.
>> Return the constant instead of using a variable.
>
>
>   The patch does more than just that, it also removes commented out code.
That was my fault. It was fixed on V2:
http://marc.info/?l=kernel-janitors&m=140155221232137&w=2

>
>> Verified by compilation only.
>
>
> [...]
>
>
>> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
>
>
> WBR, Sergei
>
>



-- 
Peter
