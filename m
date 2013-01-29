Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297Ab3A2TrP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 14:47:15 -0500
Received: from mail-da0-f51.google.com ([209.85.210.51]:44519 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913Ab3A2TrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 14:47:12 -0500
Date: Tue, 29 Jan 2013 11:47:08 -0800
From: Tejun Heo <tj@kernel.org>
To: aris@redhat.com
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH v3 4/9] devcg: expand may_access() logic
Message-ID: <20130129194708.GE6824@mtj.dyndns.org>
References: <20130129190759.117458287@napanee.usersys.redhat.com>
 <20130129190759.857103871@napanee.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130129190759.857103871@napanee.usersys.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2013 at 02:08:03PM -0500, aris@redhat.com wrote:
> In order to make the next patch more clear, expand may_access() logic.
> 
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Serge Hallyn <serge.hallyn@canonical.com>
> Signed-off-by: Aristeu Rozanski <aris@redhat.com>

Maybe convert the function to return bool while at it?

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
