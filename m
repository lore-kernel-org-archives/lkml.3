Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739Ab3BVKlq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 05:41:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50177 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754493Ab3BVKlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 05:41:45 -0500
Date: Fri, 22 Feb 2013 11:41:43 +0100
From: Michal Marek <mmarek@suse.cz>
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Cc: linux-kernel@vger.kernel.org, Julia Lawall <Julia.Lawall@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, cocci@systeme.lip6.fr
Subject: Re: [PATCH 2 1/2] coccicheck: Allow the user to give a V=
	(verbose) argument
Message-ID: <20130222104143.GE12402@pobox.suse.cz>
References: <20130129160342.28754.96853.stgit@localhost.localdomain> <20130129160337.28754.31558.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130129160342.28754.96853.stgit@localhost.localdomain> <20130129160337.28754.31558.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2013 at 05:03:37PM +0100, Bernd Schubert wrote:
> Do not run with verbosity on/off depending on the ONLINE variable,
> which gets set with C=1 or C=2, but allow the user to set the
> verbosity using kernel default make V= paramemter.
> Verbosity is off by default now.

On Tue, Jan 29, 2013 at 05:03:42PM +0100, Bernd Schubert wrote:
> On my system one of the tests failed with
> "Fatal error: exception Failure("No OCaml compiler found! Install either ocamlopt or ocamlopt.opt")".
> 
> Investigating such issues is easier if the executed command line is being shown.

I applied both patches to kbuild.git#misc, thanks.

Michal
