Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685Ab3EYFEp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 01:04:45 -0400
Received: from sandeen.net ([63.231.237.45]:56595 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862Ab3EYFEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 01:04:44 -0400
X-Greylist: delayed 389 seconds by postgrey-1.27 at vger.kernel.org; Sat, 25 May 2013 01:04:44 EDT
Message-ID: <51A044E5.1030105@sandeen.net>
Date: Fri, 24 May 2013 23:58:13 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        xfs@oss.sgi.com
Subject: Re: XFS assertion from truncate. (3.10-rc2)
References: <20130522051243.GH29466@dastard> <20130522052938.GA2573@redhat.com> <20130522055147.GI29466@dastard> <20130522215454.GL29466@dastard> <20130523184948.GA11151@redhat.com> <20130523223038.GB24543@dastard> <20130524004906.GA21171@redhat.com> <20130524012625.GH24543@dastard> <20130524015219.GA28486@redhat.com> <20130524030300.GA30760@redhat.com> <20130524080300.GI24543@dastard>
In-Reply-To: <20130524080300.GI24543@dastard>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/24/13 3:03 AM, Dave Chinner wrote:

> Right, patch below should fix the problem.
> 
> What a frustrating bug. Now, where's my bottle of scotch?

In your pantry, Dave.  Next to the others! ;)

-Eric

> Cheers,
> 
> Dave.
> 

