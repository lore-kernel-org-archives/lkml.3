Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196AbaAVDEg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 22:04:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58563 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755155AbaAVDEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 22:04:34 -0500
Message-ID: <52DF353D.6050300@redhat.com>
Date: Tue, 21 Jan 2014 22:04:29 -0500
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org
CC: linux-kernel@vger.kernel.org
Subject: [LSF/MM TOPIC] really large storage sectors - going beyond 4096 bytes
References: <20131220093022.GV11295@suse.de>
In-Reply-To: <20131220093022.GV11295@suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One topic that has been lurking forever at the edges is the current 4k 
limitation for file system block sizes. Some devices in production today and 
others coming soon have larger sectors and it would be interesting to see if it 
is time to poke at this topic again.

LSF/MM seems to be pretty much the only event of the year that most of the key 
people will be present, so should be a great topic for a joint session.

Ric

