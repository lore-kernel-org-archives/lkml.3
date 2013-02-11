Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758531Ab3BKRuq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 12:50:46 -0500
Received: from xes-mad.com ([216.165.139.218]:33884 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758378Ab3BKRup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 12:50:45 -0500
X-Greylist: delayed 2643 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Feb 2013 12:50:44 EST
Message-ID: <1360602306.7384.3.camel@petert>
Subject: Re: [PATCH 4/5] lpc_ich: Add Device IDs for Intel Wellsburg PCH
From: Peter Tyser <ptyser@xes-inc.com>
To: James Ralston <james.d.ralston@intel.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Seth Heasley <seth.heasley@intel.com>
Date: Mon, 11 Feb 2013 11:05:06 -0600
In-Reply-To: <1360373618-2091-1-git-send-email-james.d.ralston@intel.com>
References: <1360373618-2091-1-git-send-email-james.d.ralston@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.2-1ubuntu3.1~stracciatellappa+precise1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-02-08 at 17:33 -0800, James Ralston wrote:
> This patch adds the Watchdog Timer Device IDs for the Intel Wellsburg PCH

I don't have the Wellsburg documentation handy to verify the PCI device
ID values, but it looks good otherwise.

Acked-by: Peter Tyser <ptyser@xes-inc.com>

