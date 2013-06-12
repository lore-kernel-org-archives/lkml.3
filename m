Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757653Ab3FLSnO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 14:43:14 -0400
Received: from longford.logfs.org ([213.229.74.203]:59540 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755629Ab3FLSnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 14:43:12 -0400
Date: Wed, 12 Jun 2013 13:13:41 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-kernel@vger.kernel.org, target-devel <target-devel@vger.kernel.org>
Subject: Re: [PATCH] target: don't corrupt bh_count in
 iscsit_stop_time2retain_timer()
Message-ID: <20130612171341.GA2981@logfs.org>
References: <20130530203651.GB13756@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130530203651.GB13756@logfs.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 May 2013 16:36:51 -0400, Jörn Engel wrote:
> 
> I just started noticing this one.  Patch is completely untested so
> far, so don't merge it just yet.  I just wanted early review,
> considering how scary this looks.

Patch does fix a race we kept seeing at a low rate.  Nick, can you
take it as-is?

Jörn

--
Victory in war is not repetitious.
-- Sun Tzu
