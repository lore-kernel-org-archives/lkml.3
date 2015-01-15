Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbbAOPwx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 10:52:53 -0500
Received: from plane.gmane.org ([80.91.229.3]:59119 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385AbbAOPwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 10:52:51 -0500
X-Injected-Via-Gmane: http://gmane.org/
Mail-Followup-To: linux-kernel@vger.kernel.org
To: linux-kernel@vger.kernel.org
From: rh_ <richard_hubbe11@lavabit.com>
Subject: Re: [PATCH] drm/radeon/rv515: Remove unused function
Date: Thu, 15 Jan 2015 07:50:14 -0800
Organization: L2N
Message-ID: <20150115075014.75a55d5d@127>
References: <1421175345-6635-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: ip68-6-109-86.sb.sd.cox.net
User-Agent: dsodnetnin
X-Gmane-NNTP-Posting-Host: EZnn0.37p
Original-Received: from slem by 1.1 with local
X-No-Archive: yes
Archive: no
X-Archive: encrypt
X-Operating-System: Barebones_6.1
X-Gmane-NNTP-Posting-Host: 192.168.1.1
X-NNTP-Posting-Host: 192.168.1.1
Mail-Copies-To: never
X-Archive: expiry=79
X-Mailer: EZnn0.37u
X-Newsreader: EZnn0.37u
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jan 2015 19:55:45 +0100
Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se> wrote:

> Remove the function rv515_ring_start() that is not used anywhere.
> 
> This was partially found by using a static code analysis program
> called cppcheck.

What command options do you use for cppcheck?

