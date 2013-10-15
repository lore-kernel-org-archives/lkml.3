Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932566Ab3JONdk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 09:33:40 -0400
Received: from one.firstfloor.org ([193.170.194.197]:42982 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932395Ab3JONdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 09:33:39 -0400
Date: Tue, 15 Oct 2013 15:33:36 +0200
From: Andi Kleen <andi@firstfloor.org>
To: =?iso-8859-1?Q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>
Cc: Neil Horman <nhorman@tuxdriver.com>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Subject: Re: [PATCH] x86: Run checksumming in parallel accross multiple
 alu's
Message-ID: <20131015133336.GF2592@two.firstfloor.org>
References: <1381510298-20572-1-git-send-email-nhorman@tuxdriver.com>
 <87siw4xy9i.fsf@tassilo.jf.intel.com>
 <20131014202528.GG26880@hmsreliant.think-freely.org>
 <20131015091251.2345b918@b012350-ux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131015091251.2345b918@b012350-ux>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>   indeed, our typical workload is connected mode IPoIB on mlx4 QDR hardware
> where one cannot benefit from hardware offloads.

Is this with sendfile? 

For normal send() the checksum is done in the user copy and for receiving it
can be also done during the copy in most cases

-Andi
