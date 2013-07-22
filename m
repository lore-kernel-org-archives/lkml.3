Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933408Ab3GVUwL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 16:52:11 -0400
Received: from mail-wg0-f54.google.com ([74.125.82.54]:49731 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932316Ab3GVUwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 16:52:09 -0400
Date: Mon, 22 Jul 2013 22:52:03 +0200
From: Kiko Piris <kernel@pirispons.net>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Paul Bolle <pebolle@tiscali.nl>, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: Re: 3.10.1 cpufreq suspend/resume regression still present in 3.10.2
Message-ID: <20130722205203.GA8075@sacarino.pirispons.net>
Mail-Followup-To: Kiko Piris <kernel@pirispons.net>,
	"Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
	Paul Bolle <pebolle@tiscali.nl>, linux-kernel@vger.kernel.org,
	gregkh@linuxfoundation.org
References: <20130722151653.GA7213@sacarino.pirispons.net>
 <1374507247.15242.26.camel@x61.thuisdomein>
 <20130722155456.GA7836@sacarino.pirispons.net>
 <51ED56FF.9030508@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51ED56FF.9030508@linux.vnet.ibm.com>
User-Agent: Mutt
X-No-CC: Please respect my Mail-Followup-To header
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/07/2013 at 21:29 +0530, Srivatsa S. Bhat wrote:

> Try applying the two mainline commits that I mentioned in my previous
> mail, on top of 3.10.2 and check if it fixes your problem.

It does fix it.

Running 3.10.2 with your two patches, suspended and resumed a couple of
times without a problem (previously it didn’t wake up 100% of the
times).

Thank you both for your help!

Regards.

-- 
Kiko
