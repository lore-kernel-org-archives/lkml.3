Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497AbaINJmI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 05:42:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13511 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752416AbaINJmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 05:42:05 -0400
Message-ID: <541562D4.90801@redhat.com>
Date: Sun, 14 Sep 2014 11:41:40 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: linux-usb <linux-usb@vger.kernel.org>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: fix regression that accidentally disabled block-based
 tcq
References: <540EC52C.3000804@redhat.com> <20140909152730.GA17882@infradead.org> <540FFBF4.9090001@redhat.com> <20140910154535.GA5102@infradead.org> <541172E9.8070309@redhat.com> <20140911161331.GA24488@infradead.org> <54134E50.6040805@redhat.com> <20140912230032.GA21143@infradead.org> <54141C59.7040707@redhat.com> <20140913175047.GA28882@infradead.org>
In-Reply-To: <20140913175047.GA28882@infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 09/13/2014 07:50 PM, Christoph Hellwig wrote:
> On Sat, Sep 13, 2014 at 12:28:41PM +0200, Hans de Goede wrote:
>> Yes this one does the trick and fixes things. Note the git tree I used for
>> testing also had your previous fix to split up the blk_tcq union in 2
>> separate struct members. Let me know if you want me to re-test without that
>> fix.
> 
> I'm pretty sure that isn't needed, so double testing it indeed doesn't
> would be helpful.

I can confirm that things still work fine with the union left in place.

>  I'd like to add your Tested-by: tag after that, too.

Ack:

Tested-by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans
