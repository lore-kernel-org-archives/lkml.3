Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299AbaKAC5o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 22:57:44 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:55776 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbaKAC5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 22:57:42 -0400
Date: Fri, 31 Oct 2014 19:57:37 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Input: i8042 - add mux quirk for HP EliteBook
Message-ID: <20141101025737.GA20884@dtor-ws>
References: <1414535232-4780-1-git-send-email-luis.henriques@canonical.com>
 <20141028230841.GB19675@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141028230841.GB19675@dtor-ws>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 04:08:41PM -0700, Dmitry Torokhov wrote:
> On Tue, Oct 28, 2014 at 10:27:12PM +0000, Luis Henriques wrote:
> > This laptop requires active multiplexing to be enabled in order to be able
> > to separate the PS/2 mouse and the touchpad.
> > 
> > Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
> 
> Applied, thank you.

Actually I am reverting the nomux patch, so unapplied ;)

-- 
Dmitry
