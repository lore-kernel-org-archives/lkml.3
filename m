Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094Ab3LPRSd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 12:18:33 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:44079 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466Ab3LPRSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 12:18:31 -0500
MIME-Version: 1.0
In-Reply-To: <20131216170200.GT18769@lee--X1>
References: <1387194424-2701-1-git-send-email-lpapp@kde.org>
	<20131216134633.GI18769@lee--X1>
	<CAOMwXhOnHNrzEvf0+QRn6dGb42xR9a33joZcou3ancwSYe36Ug@mail.gmail.com>
	<20131216150937.GO18769@lee--X1>
	<CAOMwXhNJFGiRNB4jnTrzzpSGL8XvaR1Ph_pFrdU+x+guy7Tamg@mail.gmail.com>
	<20131216163546.GR18769@lee--X1>
	<CAOMwXhNXctcQWMU5vKKW52sQ-Ek3Mw3FZLTNJa4GD5qk4O79Gw@mail.gmail.com>
	<20131216170200.GT18769@lee--X1>
Date: Mon, 16 Dec 2013 17:18:31 +0000
X-Google-Sender-Auth: jHYZD17_JR1l7yI4S3YAFmefuGs
Message-ID: <CAOMwXhMMCFdpZbtuy8n8Xe5hSEBD=6=3mfCp29hRYtULRF6qng@mail.gmail.com>
Subject: Re: [PATCH] mfd: (max8997) Handle the potential error for mfd_add_devices
From: Laszlo Papp <lpapp@kde.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: sameo@linux.intel.com, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 5:02 PM, Lee Jones <lee.jones@linaro.org> wrote:
>> >> > No top posting please.
>> >>
>> >> Tell that to the client I need to use. IMO, making these inline posts
>> >> mandatorily when the reply is a single line makes not much sense.
>> >> Anyway, I will follow the inconvenient way.
>> >
>> > If you are not replying to a particular comment, then there is no need
>> > to quote it.
>>
>> I did not actually quote anything above my reply.
>
> No, you quoted the entire message _below_ your reply, which is worse.

Why is that bad? Cannot you just reply to the "top-post" sentence with
dropping all the quotes below if that is what you wish?

>> > Please read and inwardly digest:
>> >   Documentation/email-clients.txt
>>
>> I have read that, however I still have certain restrictions here which
>> are over the kernel community rules.  That should not block a useful
>> contribution in my opinion.
>
> Your email client does not prevent you from replying inline, which
> you've proven by this email. Please abide by the rules if you're going
> to contribute.

Yes, I can spend more effort with it inconveniently, but currently I
do not see why that is for good. Yes, I will follow, as I already
wrote, but I still do not see why that is better for anyone. :)

>> >> >> > The $SUBJECT line is wrong. To see how a subsystem usually formats
>> >> >> > theirs you must do something like `git log --oneline -- <subsystem>`.
>> >> >> > And duplicate the format.
>> >> >> >
>> >> >> > Commit message?
>> >> >
>> >> > These comments are still relevant, please re-post your patch with the
>> >> > points rectified.
>> >>
>> >> I really do not understand how they relevant. "Commit message?" ->
>> >> What about it?
>> >
>> > The issue is that there isn't one.
>>
>> I do not follow. Here is the commit message: "mfd: (max8997) Handle
>> the potential error for mfd_add_devices". What is missing? It now
>> handles an error for adding mfd devices which was not handled before.
>> It mentions for which chip. What more needs to be written? I am
>> currently lost.
>
> Please read:
>   Documentation/SubmittingPatches
>
> Specifically No2.

I had read that, but as written, I am not sure what more you want to
add. Should I replicate the title in the body, pretty much? Please be
specific, and write what you would like to see in the body. I will
copy/paste it. Currently, I am not sure.

>> >> It has a pretty clear commit message.
>> >
>> > If you are referencing my comments about the $SUBJECT line, then I
>> > have to disagree with you there. It's actually pretty vague, does not
>> > describe either the issue or what steps you've taken to rectify it.
>> >
>> >> Are you now just
>> >> picking nits about "foo:" vs "(foo)" in the short line?
>> >
>> > That is also an issue. Did you issue the command I sent you:
>> >
>> >   `git log --oneline -- drivers/mfd`
>> >
>> > Issue it now and see if _anyone_ has _ever_ used your formatting.
>>
>> Right, so nitpicking about a minor nuance over a somewhat important
>> error handling. Is that blocking the error handling change or you can
>> fix that up yourself? I currently do not have time, nor environment
>> for satisfy this request. I can probably do it the upcoming days.
>
> It's not my responsibility to fixup your patches for you. It's your
> job to ensure they are correct on submission. I am happy to review
> them for you and provide you with my comments, which I have done.
>
> Either fix them up and re-submit or don't. It's no skin off my nose.

Well, maintainers do it from time to time they apply changes when it
only needs a minor nitpick modification like this in the commit
message, but it is no problem. I am fine the linux kernel not having
this error check, at least for now. :-)

>> >> >> >> +     if (ret < 0) {
>> >> >> >> +             dev_err(dev, "cannot add mfd cells\n");
>> >> >> >> +             goto err_mfd;
>> >> >> >> +     }
>> >> >> >
>> >> >> > Have you tested this patch on h/w? Did you even compile it?
>> >> >
>> >> > You must ensure to test your patches before sending to the MLs, it's
>> >> > the very least we expect.
>> >>
>> >> I am not sure what point you are trying to make. Feel free to reject
>> >> the patch for this error handling.
>> >
>> > I'm not rejecting it because of the error handling, I'm rejecting it
>> > because it hasn't been tested and it doesn't even compile.
>>
>> It *has* been tested, and it does compile here. I think you just got
>> stuck with the old patch rather than taking any look at new version.
>> May I ask you to do please so? That has been fixed in the new
>> submission before your email.
>
> I have seen the new patch where you fixed it. My comments are solely in
> reference to this patch though. Testing patches _after_ you've sent
> them to the MLs is not acceptable.

I am afraid, you are incorrect here. I did test it before. It was a
patch sending workflow issue, but even then: why cannot we move on? It
had been fixed pretty much within a few seconds, and then I was
resending it.

> The $SUBJECT line does not conform to what's expected of MFD commits.
> The $SUBJECT line is vague and you are missing a commit body.

As written, I am lost what I would need to add to the commit message.
Please advise, and I will copy and paste that before resending.

> Why have you removed this line?

That is just noise. It is better not to remove it, thanks.

> We're adding devices here, not cells.
>  "failed to add devices"

That description is not chosen by me. Actually, that is coming from
the other mfd drivers, particularly from the other existing MAXIM mfd
driver. I would not personally break the consistency there.
