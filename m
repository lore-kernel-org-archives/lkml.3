Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216AbbAFONt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 09:13:49 -0500
Received: from smtprelay.synopsys.com ([198.182.47.9]:40617 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932164AbbAFONs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 09:13:48 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Tobias Klauser <tklauser@distanz.ch>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arc: Remove unused prepare_to_copy()
Thread-Topic: [PATCH] arc: Remove unused prepare_to_copy()
Thread-Index: AQHQKPNN1rGrXBPPD0+ZO431f5892w==
Date: Tue, 6 Jan 2015 14:13:44 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA2307565BCA3DE@IN01WEMBXA.internal.synopsys.com>
References: <1420467858-16942-1-git-send-email-tklauser@distanz.ch>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.196.223]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 January 2015 07:54 PM, Tobias Klauser wrote:

prepare_to_copy() was removed from all architectures supported at that
time in commit 55ccf3fe3f9a ("fork: move the real prepare_to_copy()
users to arch_dup_task_struct()"). Remove it from arc as well.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch><mailto:tklauser@distanz.ch>

Thx for the cleanup Tobias.

Applied to arc for-next.

Thx,
Vineet
