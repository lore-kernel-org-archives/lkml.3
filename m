Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058AbaHVLbo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 07:31:44 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:41531 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751844AbaHVLbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 07:31:43 -0400
Message-ID: <1408707084.4349.0.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH] zd1211rw: replace ZD_ASSERT with lockdep_assert_held()
From: Johannes Berg <johannes@sipsolutions.net>
To: "Sharma, Sanjeev" <Sanjeev_Sharma@mentor.com>
Cc: "dsd@gentoo.org" <dsd@gentoo.org>,
        "kune@deine-taler.de" <kune@deine-taler.de>,
        "linville@tuxdriver.com" <linville@tuxdriver.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 22 Aug 2014 13:31:24 +0200
In-Reply-To: <FDC088D3B5555644AE135ED28A7ABDE94DF2FDC2@EU-MBX-02.mgc.mentorg.com> (sfid-20140819_083957_833442_DEE44B0A)
References: <1407827133-29493-1-git-send-email-sanjeev_sharma@mentor.com>
	 <FDC088D3B5555644AE135ED28A7ABDE94DF2FDC2@EU-MBX-02.mgc.mentorg.com>
	 (sfid-20140819_083957_833442_DEE44B0A)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-08-19 at 06:39 +0000, Sharma, Sanjeev wrote:
> Ping for review the patch.

Make sure it compiles ...



