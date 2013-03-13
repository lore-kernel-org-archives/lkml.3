Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788Ab3CMAGx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 20:06:53 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:58158 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755314Ab3CMAGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 20:06:51 -0400
Message-ID: <1363133206.6887.1.camel@thor.lan>
Subject: Re: [PATCH linux-next] procfs: fix rcu-lock/unlock in
 proc_reg_open() and proc_reg_release()
From: Peter Hurley <peter@hurleysoftware.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Nathan Zimmer <nzimmer@sgi.com>
Date: Tue, 12 Mar 2013 20:06:46 -0400
In-Reply-To: <20130307072129.17719.81530.stgit@zurg>
References: <20130307072129.17719.81530.stgit@zurg>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-07 at 11:21 +0400, Konstantin Khlebnikov wrote:
> fix for a21813be23329e2788164eab532e79cb0e513cfc (linux-next)
> "procfs: improve scaling in proc"
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> Cc: Nathan Zimmer <nzimmer@sgi.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>

Konstantin,

Thanks for fixing this. Now -next boots once again :)

Regards,
Peter Hurley

