Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700AbaJEO1A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 10:27:00 -0400
Received: from lists.s-osg.org ([54.187.51.154]:39491 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359AbaJEO06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 10:26:58 -0400
Date: Sun, 5 Oct 2014 11:26:51 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: "AreMa Inc." <info@are.ma>
Cc: Antti Palosaari <crope@iki.fi>, linux-media <linux-media@vger.kernel.org>,
        Hans De Goede <hdegoede@redhat.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Peter Senna Tschudin <peter.senna@gmail.com>,
        linux-kernel@vger.kernel.org, knightrider@are.ma
Subject: Re: [PATCH] pt3 (pci, tc90522, mxl301rf, qm1d1c0042):
 pt3_unregister_subdev(), pt3_unregister_subdev(), cleanups...
Message-ID: <20141005112651.4aa60d91@recife.lan>
In-Reply-To: <CAKnK8-RRXB73=UZRzndyuQ2S19kefYkiXGn7z7PpTqDUNpp6Ow@mail.gmail.com>
References: <1412275758-31340-1-git-send-email-knightrider@are.ma>
	<542E2BF6.2090800@iki.fi>
	<CAKnK8-QOU7szWNcC1BsBZtNmHBLiLqZuCVYpjsVBkpfNCxGa-A@mail.gmail.com>
	<20141003075206.331006bd@recife.lan>
	<CAKnK8-QF7fWRzp24mhsUWuK610Ko7G=a4fEx0oyf+En+jRVoJA@mail.gmail.com>
	<CAKnK8-REiZ+Y_cjf9Lpbc+QiSpp2JZKq1wCi9_3-BNjSopzRLQ@mail.gmail.com>
	<20141005092913.1717dfc9@recife.lan>
	<CAKnK8-RRXB73=UZRzndyuQ2S19kefYkiXGn7z7PpTqDUNpp6Ow@mail.gmail.com>
Organization: Samsung
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please don't do top-posting.

(moved your comments to the end of the email)

Em Sun, 05 Oct 2014 22:04:32 +0900
"AreMa Inc." <info@are.ma> escreveu:
> 
> 2014-10-05 21:29 GMT+09:00 Mauro Carvalho Chehab <mchehab@osg.samsung.com>:
> > Hi Bud,
> >
> > Em Sun, 05 Oct 2014 18:36:54 +0900
> > "AreMa Inc." <info@are.ma> escreveu:
> >
> >> Dear Antti, Mauro & others,
> >>
> >> We don't want to flood the mailing lists with dirts.
> >> It is regretful to send this kind of email, however
> >> as we just received a "war declaration" from Tsukada Akihiro,
> >> it is better to postpone delivering PT3 driver to the main kernel tree.
> >>
> >> A series proof of facts follow.
> >>
> >> Thanks again for your appreciation.
> >> Bud @ AreMa Inc.
> >>
> >> official contacts:
> >> +81 50 5552 1666
> >> info@are.ma
> >>
> >>
> >> 2014-10-04 16:16 GMT+09:00 AreMa Inc. <info@are.ma>:
> >> > Hi Mauro,
> >> >
> >> > The biggest reason is that, the submitted driver, also published at
> >> > https://github.com/knight-rider/ptx/tree/master/pt3_dvb
> >> > is well proven to be running smoothly and already used by Japanese community
> >> > for more than a year (i.e. de facto standard) without any major issues.
> >> >
> >> > The second is more about his personal reasons in violating the rules
> >> > and we don't want to comment further unless there is no response from him
> >> > within a week.
> >> >
> >> > Many patches will follow.
> >> >
> >> > Thanks again for your info.
> >> > Regards
> >> > -Bud
> >
> > Sorry, but the PT3 driver was already merged at the main tree and I can't
> > simply remove the PT3 patches without causing problems for all other patches
> > that are ready to be submitted.
> >
> > What might be done would be to remove the driver on a separate patch,
> > but that would require a really strong reason for doing that.
> >
> > At least from where I sit, tens of thousands kilimeters away from you both,
> > it sounds to me that we're talking about two different drivers for the
> > same piece of hardware. The big diff between your driver and his shows
> > that they're very different.
> >
> > That's the history of what happened with PT3 drivers submission:
> >         https://patchwork.linuxtv.org/project/linux-media/list/?submitter=6259&state=*
> >         https://patchwork.linuxtv.org/project/linux-media/list/?submitter=6368&state=*
> >
> > All the public e-mails are there, and I don't care (not I am aware) of
> > any other e-mails exchanged in priv.
> >
> > Both drivers had issues when submitted, and both series were properly
> > reviewed. Yet, Akihiro was fast to fix the pointed issues, and his patches
> > followed the proper submission rules since the beginning. Also, the
> > per-driver patch split helped the reviewers to better do their work.
> > His series was discussed during the last 3-4 months without a single reply
> > arguing against its merge, and all comments pointing to issues at the driver
> > were fixed.
> >
> > As it followed all the submission rules and fixup requests, it got merged.
> >
> > So, I am unable to see any reason to remove his driver from the Kernel.
> >
> > Am I missing something?
>
> Yeah, sorry if we are not familiar with submission rules as it was the
> first time for us.
> We already splitted the FE and tuners as I2C drivers, according to your request.
> 
> Maybe Tsukada is very clever and we are too busy with daily business,
> but it doesn't mean that backstabbing is tolerated.
> We already asked him to join the project, in a very good manner.
> 
> The fact is that, our DVB driver is already published and used widely
> at least in Japan since August 2013
> (chardev version is far earlier) and has become a de facto standard,
> well tested without any major/minor issues
> reported. Our driver is simpler/slimmer and yet, stable. And, it
> conforms the rules of DVB core.

While looking on what happened in the past would help us to improve
future patch submissions, it won't solve the issues we're now facing,
as we cannot go back in time and fix it.

We need to move on, and the way for doing that is to submit incremental
patches improving the driver.

> Or, do you have the card with you?

As I wrote on another reply to this thread:

No, I don't have such card, nor I have any personal preference between
your version or Tsukada's one.

I might be ordering one and test here with my RF generators or ISDB-T
live, but very likely I won't have any time for coding, as my duties
as the maintainers require my attention on other things too. Also,
the problem here is not the lack of a developer for it, but, instead,
the lack of coordination between two developers.

So, I very much prefer if you could agree one with another around
a series of patches that would improve the driver without causing
regressions.

Regards,
Mauro
