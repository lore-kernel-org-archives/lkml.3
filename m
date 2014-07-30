Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648AbaG3LnS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 07:43:18 -0400
Received: from sym2.noone.org ([178.63.92.236]:45130 "EHLO sym2.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106AbaG3LnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 07:43:17 -0400
Date: Wed, 30 Jul 2014 13:43:14 +0200
From: Tobias Klauser <tklauser@distanz.ch>
To: fernando.apesteguia@gmail.com
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: vt6655: Fix device table definition.
Message-ID: <20140730114313.GG10301@distanz.ch>
References: <1406655864-8694-1-git-send-email-fernando.apesteguia@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406655864-8694-1-git-send-email-fernando.apesteguia@gmail.com>
X-Editor: Vi IMproved 7.3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-07-29 at 19:44:24 +0200, fernando.apesteguia@gmail.com <fernando.apesteguia@gmail.com> wrote:
> From: Fernando Apesteguia <fernando.apesteguia@gmail.com>
> 
> Add static to the definition of the pci device table.
> 
> Signed-off-by: Fernando Apesteguia <fernando.apesteguia@gmail.com>

This change is already part of Greg's tree, see commit
9e4c5c2837a4 ("staging: vt6655: statify some variables") in branch
staging-next. Please make sure you work against that branch (which is
also a part of linux-next) for any patches you submit.

Cheers
Tobias
