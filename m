Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959AbaGELtW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 07:49:22 -0400
Received: from mout.gmx.net ([212.227.15.15]:51701 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316AbaGELtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 07:49:21 -0400
Date: Sat, 5 Jul 2014 13:49:03 +0200
From: Marc Dietrich <marvin24@gmx.de>
To: Julian Andres Klode <jak@jak-linux.org>
Cc: Pawel Lebioda <pawel.lebioda89@gmail.com>, Marc Dietrich <marvin24@gmx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ac100@lists.launchpad.net, linux-tegra@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: nvec: remove unneccessary 'else' after
 'return'statement
Message-Id: <20140705134903.89ec088a6b90e48be9c36f89@gmx.de>
In-Reply-To: <20140704205941.GA7406@jak-x230>
References: <20140704195746.GA4346@ThinkPad>
	<20140704205941.GA7406@jak-x230>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; arm-unknown-linux-gnueabihf)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:ynenwDccR/26qxeY6+i0QhKVEOLnST8FIUvieFbXxOUjMBtdUYm
 sx9aKAddYy0iC/fZ3up0BCR5DdXRYG3HxDuVKVto2xSTh+7SmM8V6pDT5zkwd4shmWqLjId
 0DM8OUe17gRjO278c/Gp61pF75gaHsXPOOHBw36VstZZNYY+V/76HHsRhFjqXb4zQC2z7cK
 AAWuQ1NaZoXI4icLn4seA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Jul 2014 22:59:41 +0200
Julian Andres Klode <jak@jak-linux.org> wrote:

> On Fri, Jul 04, 2014 at 09:57:50PM +0200, Pawel Lebioda wrote:
> > Hi,
> >
> > This patch fixes the following warning reported by checkpatch.pl:
> > 
> > WARNING: else is not generally useful after a break or return
> > #235: FILE: drivers/staging/nvec/nvec.c:235:
> > 
> > Regards
> > Pawel Lebioda
> > 
> > Signed-off-by: Pawel Lebioda <pawel.lebioda89@gmail.com>
> >  drivers/staging/nvec/nvec.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> Hi Pawel,
> 
> Please format your patches correctly. There should be no
> "Hi", no "Regards", etc. After the signed off should be a
> dashed line.
> 
> Use git format-patch to format patches and you can send
> them using git-send-email.

yes, this way you reduce some apply-burdon from Greg. Ideally,
you would combine all patches (one patch per checkpatch warning)
in a common thread like this:

git-format-patch --cover-letter --thread -s <first commit of your
patches>

This way you could add some comments (if any) to the cover letter
and just keep the plain checkpatch message in the other patches. This
has also the advantage that the maintainers only have to ack the "cover
letter".

Marc
 
-- 
Marc Dietrich <marvin24@gmx.de>
