Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759903Ab3EXBw0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 21:52:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9976 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759223Ab3EXBwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 21:52:25 -0400
Date: Thu, 23 May 2013 21:52:19 -0400
From: Dave Jones <davej@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: XFS assertion from truncate. (3.10-rc2)
Message-ID: <20130524015219.GA28486@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Dave Chinner <david@fromorbit.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
References: <20130522040318.GG29466@dastard>
 <20130522041521.GA1837@redhat.com>
 <20130522051243.GH29466@dastard>
 <20130522052938.GA2573@redhat.com>
 <20130522055147.GI29466@dastard>
 <20130522215454.GL29466@dastard>
 <20130523184948.GA11151@redhat.com>
 <20130523223038.GB24543@dastard>
 <20130524004906.GA21171@redhat.com>
 <20130524012625.GH24543@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130524012625.GH24543@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 24, 2013 at 11:26:25AM +1000, Dave Chinner wrote:
 
 > You want to print the debug output if the masked value != 0.

XFS (sda2): xfs_setattr_size: mask 0xaa69, masked 0x801 ii 0xffff8802129e98c0, d 0xffff88021757d970 path /davej/src/trinity/tmp/tmp.5/

	Dave
