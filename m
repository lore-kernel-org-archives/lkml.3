Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128Ab3GJX4w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 19:56:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45430 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754304Ab3GJX4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 19:56:50 -0400
Date: Wed, 10 Jul 2013 19:56:36 -0400
From: Dave Jones <davej@redhat.com>
To: Paul Taysom <taysom@chromium.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, jack@suse.cz, sonnyrao@chromium.org
Subject: Re: [PATCH] fs: sync: fixed performance regression
Message-ID: <20130710235636.GA2879@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Paul Taysom <taysom@chromium.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	jack@suse.cz, sonnyrao@chromium.org
References: <1373497956-8770-1-git-send-email-taysom@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373497956-8770-1-git-send-email-taysom@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 04:12:36PM -0700, Paul Taysom wrote:
 
 > Note, when running the test, the slow down doesn't always happen
 > but most of the tests will show a slow down.
 > 
 > In response to crbug.com/240422

Just in case this ends up as the actual commit msg, that url
seems to be the wrong bug.

	Dave.
