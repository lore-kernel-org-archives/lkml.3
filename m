Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423AbaJWVrO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 17:47:14 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:48395 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbaJWVrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 17:47:13 -0400
Date: Thu, 23 Oct 2014 23:44:51 +0200
From: Alexis Berlemont <alexis.berlemont@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        mingo@kernel.org, sam@ravnborg.org, namhyung@kernel.org
Subject: Re: [PATCH 01/15] kbuild: add support of custom paths for
 "auto.conf*" files
Message-ID: <20141023214451.GA24223@marx-slim>
References: <1411422796-27049-1-git-send-email-alexis.berlemont@gmail.com>
 <1411422796-27049-2-git-send-email-alexis.berlemont@gmail.com>
 <542171E1.6090803@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <542171E1.6090803@suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Marek wrote:
> On 2014-09-22 23:53, Alexis Berlemont wrote:
> > +#define PATH_MAXLENGTH 4096
> > +const char *conf_get_autoconfigdep_name(void)
> > +{
> > +	static char res_value[PATH_MAXLENGTH];
> 
> Please use the PATH_MAX macro instead.

One month later, I take time to answer and apologize... I have some
trouble with my free time. 

Thanks you. This is fixed in the next patch set.

Alexis
