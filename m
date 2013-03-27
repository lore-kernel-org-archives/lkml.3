Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751870Ab3C0Mmm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 08:42:42 -0400
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:54712 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750932Ab3C0Mmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 08:42:39 -0400
Message-ID: <1364388152.1345.29.camel@x61.thuisdomein>
Subject: Re: [PATCH] powerpc: remove PReP
From: Paul Bolle <pebolle@tiscali.nl>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Rob Landley <rob@landley.net>,
        Adam Belay <abelay@mit.edu>, Bjorn Helgaas <bhelgaas@google.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Michael Ellerman <michael@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 27 Mar 2013 13:42:32 +0100
In-Reply-To: <CAMuHMdVs-Xxu9e=8WZbTBXE1_+iYOBKODgj9_EKmVbZA3z=8JA@mail.gmail.com>
References: <1363864206.1390.117.camel@x61.thuisdomein>
	 <20130322042159.GC26908@concordia>
	 <1364381223.1345.18.camel@x61.thuisdomein>
	 <CAMuHMdVs-Xxu9e=8WZbTBXE1_+iYOBKODgj9_EKmVbZA3z=8JA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Mar 2013 12:42:32.0865 (UTC) FILETIME=[8D1DE910:01CE2AE8]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-27 at 13:05 +0100, Geert Uytterhoeven wrote:
> This section is CHRP-specific. The cs4232 driver also worked on the
> CHRP LongTrail.
> But I don't remember if the parameter values above also applied to LongTrail.
> I do remember it didn't work without specifing the right parameters, so you
> probably want to keep this section.

My reasoning was quite simply that this file was 14 years old so that
probably nobody is using that stuff anymore. Are people actually using
CHRP (whatever that is)? Anyhow, cs4232 is mentioned in some other files
too:
    $ git grep -l -n cs4232 Documentation/ 
    Documentation/powerpc/sound.txt
    Documentation/sound/alsa/ALSA-Configuration.txt
    Documentation/sound/alsa/alsa-parameters.txt
    Documentation/sound/oss/Introduction
    Documentation/sound/oss/Tropez+

Could these few lines be dumped in one of these (except
powerpc/sound.txt, of course)?


Paul Bolle

