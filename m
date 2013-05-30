Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968096Ab3E3Joi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 05:44:38 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:38629 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968067Ab3E3Job (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 05:44:31 -0400
Message-ID: <2498DCA08BF74246977A0C0E8C419B5D@local.st.by>
From: "Victor Miasnikov" <vvm@tut.by>
To: "Olaf Hering" <ohering@suse.de>, "Haiyang Zhang" <haiyangz@microsoft.com>,
        "KY Srinivasan" <kys@microsoft.com>,
        "Patrick J. Volkerding" <volkerdi@slackware.com>,
        "Ben Hutchings" <ben@decadent.org.uk>, <stable@vger.kernel.org>
Cc: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <jasowang@redhat.com>, <olaf@aepfle.de>, <davem@davemloft.net>,
        "Richard Genoud" <richard.genoud@gmail.com>, <stable@vger.kernel.org>
References: <1365198280-23270-1-git-send-email-haiyangz@microsoft.com> <CACQ1gAi0JfJFAc822YT5xVfW8HkB8r_4rf0dXTNsi-1oChsPsQ@mail.gmail.com> <00D0FAD3528A443BAEA3E39861B3CFAD@local.st.by> <1369710646.3469.424.camel@deadeye.wl.decadent.org.uk>
Subject: ToDo: backport to v3.2 patches Fw: use hv_storvsc instead of ata_piix for IDE disks ( but not for the CD-ROM) Re: Kernel v3.2 used in SlackWare 14.00 please, backport all needed patches
Date: Thu, 30 May 2013 12:44:23 +0300
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="utf-8";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.3790.4548
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4913
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

B.H.>  I think Slackware might do better to
B.H.> backport the Hyper-V drivers from Linux 3.4,

 In SlackWare 14.1 used Linux Kernel v3.8.X
with already fixed source code
i.e. "use hv_storvsc instead of ata_piix for IDE disks ( but not for the CD-ROM)"
work as need

 But, in SlackWare 14.00 (  actual stable version of SlackWare)
used Linux Kernel v3.2

(  Because backport requested at 2012-06-08  ( and apply to v3.4 -- Thanks!) has been ignored ( linux-3.2.45.tar.xz has 
non-fixed ata_piix.c) in part v3.2

  I ask about backport on 08/16/2012 09:53 AM :

----- Original Message ----- 
From: "Patrick J. Volkerding"
To: "Victor Miasnikov" vvm
Sent: Thursday, August 16, 2012 7:00 PM
Subject: Re: b3) Please: backport to Slackware 14.0 patches 1b) db63a4c8115a libata 1) cd006086fa5d ata_piix Fw: 
Slackware 14.0 RC2 in virtual computer ( guest ) on Hyper-V

On 08/16/2012 09:53 AM, Victor Miasnikov wrote:
> Thanks! LAN & SCSI *.ko related Hyper-V work as need
> Please: backport to Slackware 14.0 patches 1b) db63a4c8115a libata 1) cd006086fa5d ata_piix

 . . . ( skipped by VVM:  as possible non-public msg.)

Pat
--
)


B.H.> as Debian and Ubuntu have done with 3.2-based kernels.

 Yes: backport source code related  Hyper-V -- is right solution


B.H.> But that sort of large backport isn't allowed on kernel.org stable branches.

 I know -- see later "June 04, 2012 3:33 PM"


B.H.> I'm not going to read through all of what you wrote . . . ( skipped by VVM)


 No problem, read this:
-- June 08, 2012
-- v3.2.X
--   cd006086fa5d
--   db63a4c8115a
---  URL near phrase "way to cleanly identify Hyper-V but not Virtual PC 7"

{{{
need backport requested at 2012-06-08(!) :
  . . .
( look on sub-string "3.2")

http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg439101.html

 Or
==
----- Original Message ----- 
From: "Victor Miasnikov"
To: "Greg KH" ; "Jonathan Nieder" ; "Andy Whitcroft"
Cc: <stable@vger.kernel.org>; <linux-kernel@vger.kernel.org>; "KY Srinivasan"; "Mike Sterling"
Sent: Friday, June 08, 2012 1:36 PM
Subject: Re: Re: ToDo: backport to v3.4 , v3.3 , v3.2 patches 1b) db63a4c8115a libata 1) cd006086fa5d ata_piix: defer
disks to the Hyper-V drivers by default Fw: use hv_storvsc instead of ata_piix for IDE disks ( but not for the CD-ROM)

 . . .

{
> > > Hyper-V admins need _worked_ Linux v3.4.X / v3.3.X / v3.2.X
> > > Please, _fix_ errors related "use hv_storvsc instead of ata_piix to
> > > handle the IDE disks devices ( but not for the CD-ROM)"

  i.e. need backport to all actual version after 3.1

  cd006086fa5d ata_piix: defer disks to the Hyper-V drivers by default

and its prerequisite

  db63a4c8115a libata: add a host flag to ignore detected ATA devices
}
==
}}}


{{{
> Still, if there is a way to cleanly identify Hyper-V but not Virtual PC 7, this would be great!

FIXed: ef773e1..bec35f4

 Write in
https://bugzilla.kernel.org/show_bug.cgi?id=52821
}}}


}}}}




B.H.>  In short, you need to identify the commit hash for each of the changes you want,
B.H.> and provide the backported patch for any commits
B.H.> that can't simply be cherry-picked.

 IMHO:

VVM>  In short, MS_HV_Team need to identify the commit hash for each of the changes MS_HV_Team want,
VVM> and provide the backported patch for any commits
VVM> that can't simply be cherry-picked.





B.H.> Please read Documentation/stable_kernel_rules.txt.

 Already . . .

 Ben, please remember:

==
----- Original Message ----- 
From: "Victor Miasnikov" vvm
To:
Cc: <stable (at)  vger.kernel.org>;  . . .
Sent: Monday, June 04, 2012 3:33 PM
Subject: Re: Linux on Hyper-V 1) cd006086fa5d ata_piix: defer disks to the Hyper-V drivers by default 2) db63a4c8115a 
libata: add a host flag to ignore detected ATA device FW: use hv_storvsc instead of ata_piix to handle the IDE disks 
devices ( but not for the ...

Hi!

VVM > > > Hyper-V admins need _worked_ Linux v3.4.X / v3.3.X / v3.2.X
VVM > > >
VVM > > > Please, _fix_ errors related "use hv_storvsc instead of ata_piix to
VVM > > > handle the IDE disks devices ( but not for the CD-ROM)"


 . . .

> Lots of things would be "nice",
> but as this doesn't meet the stable_kernel_rules.txt rules, sorry, I can't take them.

 IMHO, patches "does meet the stable_kernel_rules.txt rules" by _all_ criterias . . .

 See info correlated with rules:
==
Rules on what kind of patches are accepted, and which ones are not, into the
"-stable" tree:

{
 - It must be obviously correct and tested.

 Tested ( but, in early implementaition): Ubuntu 12.04 + OpenSUSE

}

{

- It cannot be bigger than 100 lines, with context.


79 lines
 +
47 lines
}
  . . .
==




Best regards, Victor Miasnikov
Blog:  http://vvm.blog.tut.by/




----- Original Message ----- 
From: "Ben Hutchings"
To: "Victor Miasnikov"
Cc: . . .
Sent: Tuesday, May 28, 2013 6:10 AM
Subject: Re: Kernel v3.2 used in SlackWare 14.00 please, backport all needed patches Re: [PATCH net, 1/2] hyperv: Fix a
kernel warning from netvsc_linkstatus_callback()

On Thu, 2013-05-23 at 16:14 +0300, Victor Miasnikov wrote:
> Hi!
>
> > (the 3.2 version is different,
> > and it's instaging. (at not used by distros anyway))
>
>  No: used
>
> Linux Kernel v3.2 used in:
> -- SlackWare 14.00
>
> This is actual stable version SlackWare
>
> Please, backport all(!) needed patches
[...]
> P.P.P.P.P.S.
>
> Sorry, if my msg not full "political correct"
>
> I preffered solve problem as possibily earler, what wait big problems
>
> Sorry, again . . .

Please read Documentation/stable_kernel_rules.txt.  In short, you need
to identify the commit hash for each of the changes you want, and
provide the backported patch for any commits that can't simply be
cherry-picked.  I'm not going to read through all of what you wrote to
work out exactly what's needed.

I think Slackware might do better to backport the Hyper-V drivers from
Linux 3.4, as Debian and Ubuntu have done with 3.2-based kernels.  But
that sort of large backport isn't allowed on kernel.org stable branches.

Ben.

-- 
Ben Hutchings 

