Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015AbaIVVA5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 17:00:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56716 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754835AbaIVVAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 17:00:55 -0400
Message-ID: <54208E03.8030906@redhat.com>
Date: Mon, 22 Sep 2014 14:00:51 -0700
From: Andy Grover <agrover@redhat.com>
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
CC: Alex Elsayed <eternaleye@gmail.com>, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] target: Add a user-passthrough backstore
References: <1410822750-10717-1-git-send-email-agrover@redhat.com>	 <1410822750-10717-5-git-send-email-agrover@redhat.com>	 <1411161279.23258.26.camel@haakon3.risingtidesystems.com>	 <lvi81j$ud8$2@ger.gmane.org>	 <1411169965.23258.45.camel@haakon3.risingtidesystems.com>	 <lvifie$emi$3@ger.gmane.org> <541CCBD1.8050606@redhat.com> <1411419532.24986.36.camel@haakon3.risingtidesystems.com>
In-Reply-To: <1411419532.24986.36.camel@haakon3.risingtidesystems.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2014 01:58 PM, Nicholas A. Bellinger wrote:
> So I'd still like to start for an initial merge with the two different
> modes mentioned earlier.  The pure-passthrough mode where everything is
> handled by user-space, and an I/O passthrough mode where only
> SCF_SCSI_DATA_CDB is passed along to userspace, but all other control
> CDBs are handled by existing in-kernel emulation.
>
> Andy, can you re-spin a series with these two approaches in mind..?

Will do. This is actually close to what the initial RFC version I posted 
did.

-- Andy


