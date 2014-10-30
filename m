Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569AbaJ3ATD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 20:19:03 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:42428 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756713AbaJ3ATB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 20:19:01 -0400
Message-ID: <1414628335.2230.1.camel@mybabylon.net>
Subject: Re: [PATCH v3 1/1] staging: skein: Removes skein_debug include
From: Eric Rost <eric.rost@mybabylon.net>
To: gregkh@linuxfoundation.org
Cc: jason@lakedaemon.net, jake@lwn.net, antonysaraev@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Wed, 29 Oct 2014 19:18:55 -0500
In-Reply-To: <20141030001207.GA5219@localhost>
References: <20141030001207.GA5219@localhost>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-29 at 19:12 -0500, Eric Rost wrote:
> Removes skein_debug.h include since skein_debug.h is nonexistent.
> Removes unneeded debug empty macro defines and their uses.
> 
> Signed-off-by: Eric Rost <eric.rost@mybabylon.net>
> ---

Jason,

I wanted you to take one last look at this before I put reviewed-by on
it, as I snipped one more piece of SKEIN_DEBUG that I found in the
middle of skein_block.c

thx,
Eric


