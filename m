Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147Ab3EIIHs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 04:07:48 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:32906 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044Ab3EIIHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 04:07:45 -0400
Date: Thu, 9 May 2013 09:07:42 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Denis Efremov <yefremov.denis@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        trivial@kernel.org, ldv-project@linuxtesting.org
Subject: Re: [PATCH 02/21] fs: remove inline marking of EXPORT_SYMBOL
 functions
Message-ID: <20130509080742.GE25399@ZenIV.linux.org.uk>
References: <1368086241-9357-1-git-send-email-yefremov.denis@gmail.com>
 <1368086323-9412-2-git-send-email-yefremov.denis@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368086323-9412-2-git-send-email-yefremov.denis@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 09, 2013 at 11:58:24AM +0400, Denis Efremov wrote:
> EXPORT_SYMBOL and inline directives are contradictory to each other.
> The patch fixes this inconsistency.

What makes them contradictory, in your opinion?  With references to
relevant parts of C99, please.
