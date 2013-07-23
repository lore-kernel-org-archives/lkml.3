Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934243Ab3GWUfp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 16:35:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39939 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933584Ab3GWUfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 16:35:44 -0400
Date: Tue, 23 Jul 2013 13:35:43 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peng Tao <bergwolf@gmail.com>
Cc: linux-kernel@vger.kernel.org, "John L. Hammond" <john.hammond@intel.com>,
        Peng Tao <tao.peng@emc.com>, Andreas Dilger <andreas.dilger@intel.com>
Subject: Re: [PATCH 21/48] staging/lustre/obdclass: use a dummy structure for
 lu_ref_link
Message-ID: <20130723203543.GA24844@kroah.com>
References: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
 <1374509230-3324-22-git-send-email-bergwolf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374509230-3324-22-git-send-email-bergwolf@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 12:06:42AM +0800, Peng Tao wrote:
> From: "John L. Hammond" <john.hammond@intel.com>
> 
> Move the definition of struct lu_ref_link to lu_ref.h.  If USE_LU_REF
> is not defined then define it to be the empty struct.  Change the
> return type of lu_ref_add() and lu_ref_add_atomic() to void.  Add
> lu_ref_add_at() taking same arguments as lu_ref_add() togerther with a
> pointer to a struct lu_ref_link and returning void.  Adjust all
> structures containing a lu_ref_link pointer to contain a struct
> lu_ref_link instead.  Use lu_ref_add_at() and lu_ref_del_at() to
> handle embedded lu_ref_links.
> 
> Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3059
> Lustre-change: http://review.whamcloud.com/5920
> Signed-off-by: John L. Hammond <john.hammond@intel.com>
> Reviewed-by: Alex Zhuravlev <alexey.zhuravlev@intel.com>
> Reviewed-by: Jinshan Xiong <jinshan.xiong@intel.com>
> Reviewed-by: Mike Pershin <mike.pershin@intel.com>
> Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
> Signed-off-by: Peng Tao <tao.peng@emc.com>
> Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>

This patch fails to apply :(

