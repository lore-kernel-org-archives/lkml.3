Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285AbaKSLR4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 06:17:56 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:58574 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbaKSLRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 06:17:54 -0500
Date: Wed, 19 Nov 2014 13:17:44 +0200
From: Johan Hedberg <johan.hedberg@gmail.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chan-yeol Park <chanyeol.park@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, linville@tuxdriver.com,
        linux-wireless@vger.kernel.org
Subject: Re: pull request: bluetooth-next 2014-11-07
Message-ID: <20141119111744.GA8153@t440s.lan>
Mail-Followup-To: "Kirill A. Shutemov" <kirill@shutemov.name>,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
	Chan-yeol Park <chanyeol.park@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
References: <20141118133459.GB27428@node.dhcp.inet.fi>
 <20141118180919.GA32128@t440s.P-661HNU-F1>
 <20141119110654.GA1894@node.dhcp.inet.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141119110654.GA1894@node.dhcp.inet.fi>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kirill,

On Wed, Nov 19, 2014, Kirill A. Shutemov wrote:
> > From: Johan Hedberg <johan.hedberg@intel.com>
> > Date: Tue, 18 Nov 2014 20:00:15 +0200
> > Subject: [PATCH] Bluetooth: Fix setting state back to TASK_RUNNING
> > 
> > In __hci_cmd_sync_ev() and __hci_req_sync() if the hci_req_run() call
> > fails and we return from the functions we should ensure that the state
> > doesn't remain in TASK_INTERRUPTIBLE that we just set it to. This patch
> > fixes missing calls to set_current_state(TASK_RUNNING) in both places.
> > 
> > Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
> 
> This patch helps -- warning is gone.

Thanks! I've resent it to linux-bluetooth with the appropriate
Reported-by/Tested-by credits. It'll be included in the next pull
request for the bluetooth-next tree.

Johan
