Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374AbaEEI3z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 04:29:55 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:39546 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755242AbaEEI3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 04:29:53 -0400
Date: Mon, 5 May 2014 10:29:48 +0200
From: Levente Kurusa <levex@linux.com>
To: Dominique van den Broeck <domdevlin@free.fr>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] staging/rtl8192e: userspace ptr deref + incorrect
 declarations
Message-ID: <20140505082948.GA2581@linux.com>
References: <1399214787-15675-1-git-send-email-domdevlin@free.fr>
 <20140504174823.GA26361@linux.com>
 <1399247989.2485.6.camel@wisdom>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Nq2Wo0NMKNjxTN9z"
Content-Disposition: inline
In-Reply-To: <1399247989.2485.6.camel@wisdom>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, May 05, 2014 at 01:59:49AM +0200, Dominique van den Broeck wrote:
>=20
> Good evening,
>=20
> Forgive my mistakes, I sent only a few patches yet and I'm still learning.
> Nevertheless:

Not a problem at all, since that is what the challenge is for.

>=20
> > What is that period in the commit message? And the semicolon?
>=20
> Semicolons is what one use to ponctuate an enumerated list (at least
> in french). In fact, it was their primary use before computer era.
>=20
> Is there something wrong with it ? I check all my patches with
> checkpatch.pl --strict before sending them and it didn't seem to
> complain...

Oh, I see now! Well I guess it's better to have a commit message
that says WHY the change is good and WHAT did it change, not just
a list of what you did.

i.e. in this case you could also inline the sparse warning or at least
a part of it.

>=20
> > You should also be a bit more specific. Also, the Subject line is
> > very bad. Better go with something like this:
> >=20
> > staging: rtl8192e: fix userspace pointer dereference
>=20
> Right. I used the slash as a subpart of the tree. Didn't know what
> was the best for this situation.

That is good as well, I just prefer the latter one, but feel
free to use whichever you feel better. :-)

>=20
> > And when you resend a patchset, please resend the full patchset.
>=20
> I usually do but I've got an acceptation message for the first one
> (see below).
>=20

In that case, that's good.

> > This is totally unneccessary.
>=20
> Should at least have gone in the body below indeed.
>=20
> > When you cite a commit please don't include the full hash, that is
> > non informational. Better put the first 7 characters of the hash and
> > the first line of the commit message as well in parantheses, like so:
> >
> > 5169af2 ("Staging: rtl8192e: Fix declaration of symbols")
> > (I even have a command for this in vim :-) )
>=20
> I'm interested. I use vim too.
>=20

I have this:
----------%<-----------
function! GetGitCommit(commit)
    exec ":.!git log --oneline --pretty=3D\"format:\\%h ('\\%s')\" ".a:comm=
it." -1"
endfunction
---------->%-----------

> > Are you sure that 1/2 was applied to the staging tree?
> > It's unlikely that 1/2 is applied while 2/2 is left alone.
>=20
> As stated before, I received the common automatic mail from
> Greg KH regarding this one. So I'll now wait before I do a v3
> for this issue. If so, I'll resent the complete set if required.

No, if that was applied it's unneccessary to resend the full set.

>=20
> > Oh, I am unable to find commit b5c8d48 in Linus' or staging-next.
> > In which tree is it?
>=20
> It's linux-next. If I quote a commit, I should the tree as well,
> indeed. But since the v1 was performed partially for the Eudyptula
> Project and since it was a response to a modification request,=20
> I though it was implicit.

No, the tree's name is not needed. In fact, I should have checked it
in linux-next, but I only checked Linus', and staging-next thinking,
since you said it was applied, it was applied to staging-next. :-)
>=20
> > Could you please as well remove that empty line in the declarations?
>=20
> I'll do.
> Cheers.

Regards,
Levente Kurusa

--Nq2Wo0NMKNjxTN9z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJTZ0v8AAoJELBqK2lO9dZB3wsH/26UHFEuEC0eIfhgf7NIKJ3P
5WNO/eyQ1y9MOIpt+fifGYSmgBkkPC2bLCvFshQs21tmbPp62JhmXBz3BcFfCRUN
WlvnuCK+6Uf3DGut87WDfxCMQNRpELf/0jl/8SARrjnUR4JeXp+HiB9pqq7XepHs
9RDyS8gTPN0buDqCurC3EOoP6JYk3po7TSL2XE8HEVU3z5kUT/nvU4QYIOBK13rM
bZE/64fu3UvVtzUmG6r5rYXnOALEBPSFQJzTBtJbyDdarq7c9qIRT2rEX1tGszVn
131TjvVXDA9Nm3ufTMQgZikfk2kfOn7SvNJiFIVDVof6/8Hu0RNDaAuI4JUhT3w=
=C27E
-----END PGP SIGNATURE-----

--Nq2Wo0NMKNjxTN9z--
