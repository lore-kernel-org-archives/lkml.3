Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065AbaFPHMR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 03:12:17 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:43421 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152AbaFPHMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 03:12:16 -0400
From: Thomas Schwinge <thomas@codesourcery.com>
To: Jerome Glisse <j.glisse@gmail.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, <linux-pci@vger.kernel.org>,
        "Johannes Weiner" <hannes@cmpxchg.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@surriel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Zlatko Calusic <zcalusic@bitsync.net>,
        Minchan Kim <minchan@kernel.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Christian =?utf-8?Q?K=C3=B6nig?= <christian.koenig@amd.com>,
        <dri-devel@lists.freedesktop.org>
Subject: Re: radeon: screen garbled after page allocator change, was: Re: [patch v2 3/3] mm: page_alloc: fair zone allocator policy
In-Reply-To: <87ppk1q3iq.fsf@schwinge.name>
References: <1375457846-21521-1-git-send-email-hannes@cmpxchg.org> <1375457846-21521-4-git-send-email-hannes@cmpxchg.org> <87r45fajun.fsf@schwinge.name> <20140424133722.GD4107@cmpxchg.org> <20140427033110.GA15091@gmail.com> <20140427195527.GC9315@gmail.com> <87ppk1q3iq.fsf@schwinge.name>
User-Agent: Notmuch/0.9-101-g81dad07 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 16 Jun 2014 09:11:52 +0200
Message-ID: <87vbs1z5tz.fsf@schwinge.name>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg=pgp-sha1;
	protocol="application/pgp-signature"
X-OriginalArrivalTime: 16 Jun 2014 07:11:56.0693 (UTC) FILETIME=[4212C450:01CF8932]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi!

On Mon, 28 Apr 2014 10:09:17 +0200, I wrote:
> On Sun, 27 Apr 2014 15:55:29 -0400, Jerome Glisse <j.glisse@gmail.com> wr=
ote:
> > If my ugly patch works does this quirk also work ?
>=20
> Unfortunately they both don't; see my other email,
> <http://news.gmane.org/find-root.php?message_id=3D%3C87sioxq3rx.fsf%40sch=
winge.name%3E>.

> [...] hacked around as follows: [...]

> If needed, I can try to capture more data, but someone who has knowledge
> of PCI bus architecture and Linux kernel code (so, not me), might
> probably already see what's wrong.

The problem "solved itself": the machine recently died of hardware
failure.  ;-|


Gr=C3=BC=C3=9Fe,
 Thomas

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJTnpi4AAoJENuKOtuXzphJSy4H/iVeV8s9nQDKTRe0H+6VuyOa
joqGgQkfanZ35xocDxEStKDD/HP5szeCE87m0dseuHqZusIH5Npeb5dNH8Ss5cZA
4htw5IFTqDSOw5Dv2zfuAagPf0uCLAtqJv55FHlpI4kwWmeKISAkb9OAyUK/f1oA
Wu1KbriIm9D2nFL1R1yTfvC9NYLuGDOvL4sis+4IqTRRIpeTZMAMDwwE/cBygPDE
4+No5wYStNsqgu8uxQTU5arNtPFK8uDK/9+lKYkXU4TyFhpOEJEKQNStLRSNtq6s
//0748KW1HdE2/9yfXbfDfrGtXNpWMFarvOXkOT4/iCvzfQ2nf1+9N1pF0VxnQg=
=wH4w
-----END PGP SIGNATURE-----
--=-=-=--
