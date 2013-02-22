Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756950Ab3BVM5O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 07:57:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55951 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756353Ab3BVM5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 07:57:10 -0500
Date: Fri, 22 Feb 2013 13:57:09 +0100
From: Michal Marek <mmarek@suse.cz>
To: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH v2] Unset langage specific variables in setlocalversion
	script
Message-ID: <20130222125709.GJ12402@pobox.suse.cz>
References: <201302220859.r1M8xIKl029662@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201302220859.r1M8xIKl029662@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2013 at 09:59:18AM +0100, Christophe Leroy wrote:
> This patch allows the use of setlocalversion script regardless of the language
> parameters. Otherwise, the `svn info 2>/dev/null | grep '^Last Changed Rev'`
> returns nothing because for instance, in French the text 'Last Changed Rev'
> is replaced by 'Révision de la dernière modification'
> 
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

Thanks, applied to kbuild.git#kbuild.

Michal
