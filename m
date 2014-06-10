Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960AbaFJIwL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 04:52:11 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:44366 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbaFJIwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 04:52:08 -0400
Date: Tue, 10 Jun 2014 10:51:57 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Zhouyi Zhou <zhouzhouyi@gmail.com>
Cc: paulus@samba.org, mingo@redhat.com, acme@kernel.org, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zhouyi Zhou <yizhouzhou@ict.ac.cn>
Subject: Re: [PATCH 1/1] perf/amd: NULL return of kzalloc_node should be
 handled
Message-ID: <20140610085157.GX6758@twins.programming.kicks-ass.net>
References: <1402385858-23181-1-git-send-email-zhouzhouyi@gmail.com>
 <20140610082202.GX3213@twins.programming.kicks-ass.net>
 <CAABZP2x9ag6eAsL0si9j_TQNjM7jjTDf2UgYZ6ZtqBr2t_zQKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QHp3Wr1K3N9pKO2V"
Content-Disposition: inline
In-Reply-To: <CAABZP2x9ag6eAsL0si9j_TQNjM7jjTDf2UgYZ6ZtqBr2t_zQKQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QHp3Wr1K3N9pKO2V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 10, 2014 at 04:45:46PM +0800, Zhouyi Zhou wrote:
> Thanks Peter for reviewing, and sorry for not think it thoroughly
> before submitting.
> Is that ok that when amd_uncore_cpu_up_prepare is called from
> amd_uncore_cpu_notifier
> I return notifier_from_errno(-ENOMEM), and  when
> amd_uncore_cpu_up_prepare is called from
> amd_uncore_init I immediately return  -ENODEV?

That sounds about right. Thanks!

--QHp3Wr1K3N9pKO2V
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTlsctAAoJEHZH4aRLwOS6RqkP/1N7YY+8VbKD2lg32Scq8Ffe
YBEaluGJ/Hjlc8ENZN4L2c60f7BJhi7YcnZZRsPFPuds4csdjfm23CByc34pL0QW
LZMxDEXZ5ZWk5XRgWOPa8N2AxFEAPT+EZk5pfOt7J9Ct1UQpCAuRyGUI3YfsndLS
cZfrGm+1ZFx7o2PFg/MJSZCHJGXnxeQnGSTri1Y6ALnKlDRkb1KKShvYpitp/98m
uVEP875uirGNTpuGakZgW0xRku++vCMzksPCF3/j7Kj1lnq5IH6fH2C7ZziH1Hy2
SJzXOmY5jtnhZnzAZzkb61kFpmMYbXZLpKpHODSgPNWPmSAgla0lBNn3EM9F9ErX
V7DABCZmnFmPsG/LC5WI0SPs9x1SG+ZRGYeFjK4qX/OdptJuZV6tNkWPus9DVriM
7YAbXThHn84KqsG4UKY6ggH5RqwGhnCYhOUlCNEOJy6ub6GQQHgBi75foqGvh94/
HiiAI3Jog9hpAyjRJbGnTrjSessJq+LU39VBHefjARjYa76ZYzFRKq20DhDmw07x
RmQWpgCz4UlvhcmHm3PJeS73RiTbKyUYv4yuClWXr9ZqK2DUhoubuQerzIataXF3
artJOpT/DxvDBxCe5i8JFahLME2UxqeCL46IAjCPk0Z3UZfeYTATTX7/zozQrFlc
M+dieq0N1fsDmH4eiLIA
=kFCH
-----END PGP SIGNATURE-----

--QHp3Wr1K3N9pKO2V--
