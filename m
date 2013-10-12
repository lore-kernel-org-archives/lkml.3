Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641Ab3JLQ7C (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 12:59:02 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:52336 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258Ab3JLQ7A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 12:59:00 -0400
MIME-Version: 1.0
X-Originating-IP: [190.2.98.235]
In-Reply-To: <524EC022.2050203@gmail.com>
References: <1380891203-17617-1-git-send-email-ezequiel@vanguardiasur.com.ar>
	<1380891203-17617-2-git-send-email-ezequiel@vanguardiasur.com.ar>
	<524EC022.2050203@gmail.com>
Date: Sat, 12 Oct 2013 13:58:59 -0300
Message-ID: <CAAEAJfCmnMFWnSRcWN946fc615po4zAn0a-yUSUnYeTjObXr_w@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] Input: rotary-encoder: Add 'stepped' irq handler
From: =?ISO-8859-1?Q?Ezequiel_Garc=EDa?= <ezequiel@vanguardiasur.com.ar>
To: Daniel Mack <zonque@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry,

On 4 October 2013 10:18, Daniel Mack <zonque@gmail.com> wrote:
> On 04.10.2013 14:53, Ezequiel Garcia wrote:
>> Some rotary-encoder devices (such as those with detents) are capable
>> of producing a stable event on each step. This commit adds support
>> for this case, by implementing a new interruption handler.
>>
>> The handler needs only detect the direction of the turn and generate
>> an event according to this detection.
>
> I think you can squash patch 2/2 into this one. It doesn't make much
> sense to have a one-liner patch to just update the documenation separately.
>
> Other than that, the code looks fine to me.
>
>   Acked-by: Daniel Mack <zonque@gmail.com>
>

Could you merge these two patches?

It's already acked by Daniel, and there wasn't any other feedback
so I think we're ready to get them in and support more devices :-)
-- 
Ezequiel García, VanguardiaSur
www.vanguardiasur.com.ar
