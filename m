Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937Ab3F0A0N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 20:26:13 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:54146 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751663Ab3F0A0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 20:26:12 -0400
Message-ID: <1372292770.2172.2.camel@joe-AO722>
Subject: Re: [PATCH] staging: ozwpan: Convert printk to dev_dbg()
From: Joe Perches <joe@perches.com>
To: Jason Baron <jasonbaron0@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Rupesh Gujare <rupesh.gujare@atmel.com>, devel@linuxdriverproject.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        shigekatsu.tateno@atmel.com, jim.cromie@gmail.com, trenn@suse.de
Date: Wed, 26 Jun 2013 17:26:10 -0700
In-Reply-To: <51CB2907.4010100@gmail.com>
References: <1372177802-11360-1-git-send-email-rupesh.gujare@atmel.com>
	 <20130625170205.GA21328@kroah.com> <1372181390.1245.68.camel@joe-AO722>
	 <51CB2907.4010100@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-26 at 13:46 -0400, Jason Baron wrote:

> echo "grouping control_var level N +p" > /debugfs/dynamic_debug/control
> 
> or
> 
> echo "grouping control_var mask 0xN +p" > /debugfs/dynamic_debug/control
> 
> So we can think of the 'control_var' as 'grouping' debug statements
> together. So it would provide a nice way of associating statements
> together other than the existing: module, func, file, format, and line
> selectors.

As well as making them compatible with the current
module debug control vars by using their address when
appropriate.


