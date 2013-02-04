Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab3BDNJP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 08:09:15 -0500
Received: from mx2.promwad.com ([195.222.87.218]:48405 "EHLO mx2.promwad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754151Ab3BDNJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 08:09:14 -0500
Date: Mon, 4 Feb 2013 16:08:58 +0300
From: Michail Kurachkin <michail.kurachkin@promwad.com>
X-Mailer: The Bat! (v3.64.01 Christmas Edition) Professional
Reply-To: promwad_imap <michail.kurachkin@promwad.com>
Organization: promwad
X-Priority: 3 (Normal)
Message-ID: <6757302.20130204160858@promwad.com>
To: Oliver Neukum <oneukum@suse.de>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kuten Ivan <Ivan.Kuten@promwad.com>,
        "benavi@marvell.com" <benavi@marvell.com>,
        Palstsiuk Viktar <Viktar.Palstsiuk@promwad.com>
Subject: Re[2]: TDM bus support in Linux Kernel [PATCH]
In-Reply-To: <1445550.3M3gD8CvZe@linux-5eaq.site>
References: <F7F628C32E67B04DAECC5CA53521253E5FAB15CE@sv-exmb01-lo1.promwad.corp> <1445550.3M3gD8CvZe@linux-5eaq.site>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oliver,

Thank you for the code review. I am working on the sources and soon
will send you the update.

By the way, I did not find suitable implementation of software circular buffer management. src/include/linux/circ_buf.h seems to be very limited solution. 
What do you think about adding the following functions/macros to the global namespace?

int cb_init(struct circ_buf *cb, int item_size, int count);
void cb_free(struct circ_buf *cb);
int cb_push(struct circ_buf *cb, void *item);
int cb_pop(struct circ_buf *cb, void *item);
int cb_is_full(struct circ_buf *cb);
int cb_is_empty(struct circ_buf *cb);

> On Wednesday 30 January 2013 12:37:25 Kurachkin Michail wrote:
>> Hi Greg,
>> 
>> I followed your recommendations and created a diff using Linux 3.8-rc5 sources. Please review it and give your comments.


--
Kurochkin Michail
Software engineer
Promwad Innovation Company
22, Olshevskogo St.,
220073, Minsk, BELARUS
phone: +375 17 312-1246 ext. 801
mobile: +375 29 609-1024
mail: Michail.Kurachkin@promwad.com
www: www.promwad.com


