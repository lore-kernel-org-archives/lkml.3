Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab3JaSOB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 14:14:01 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:41170 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484Ab3JaSOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 14:14:00 -0400
Date: Thu, 31 Oct 2013 19:13:58 +0100
From: Andreas Mohr <andi@lisas.de>
To: =?us-ascii?B?PT9HQjIzMTI/Qj91cXZBMmc9PT89?= <bonben1989@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: A simple question of a linux kernel beginner
Message-ID: <20131031181358.GA27027@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK2Ky6x+wiwa5F6+K+Ee0y_TkbG-oA3tDBWp+2wO8mPqSTyQnA@mail.gmail.com>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> May I can use  the ''double" as a  basic variables?

[see other replies]


Look into terminus technicus "scaling math" as a replacement technique
(in-kernel this is being used e.g. by clocksources/clockevents).

HTH,

Andreas Mohr
