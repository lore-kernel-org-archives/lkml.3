Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145Ab3AXJz7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 04:55:59 -0500
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:58244 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750966Ab3AXJz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 04:55:56 -0500
Message-ID: <1359021353.1325.1.camel@x61.thuisdomein>
Subject: Re: linux-3.7.4: BUG: unable to handle kernel NULL pointer
 dereference at target_fabric_port_link
From: Paul Bolle <pebolle@tiscali.nl>
To: Kouichi ONO <kou1.ono@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Date: Thu, 24 Jan 2013 10:55:53 +0100
In-Reply-To: <20130124.010724.710820132553071688.kou1.ono@gmail.com>
References: <20130124.010724.710820132553071688.kou1.ono@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Jan 2013 09:55:53.0697 (UTC) FILETIME=[FF897510:01CDFA18]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-24 at 01:07 +0900, Kouichi ONO wrote:
> At target_fabric_port_link(), struct se_device *dev is used before set?

It seems the (stable specific) patch in
http://article.gmane.org/gmane.linux.kernel.stable/40880 should fix
that.


Paul Bolle

