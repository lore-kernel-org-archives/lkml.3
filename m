Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671AbaKGN5b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 08:57:31 -0500
Received: from dovecot.logic.tuwien.ac.at ([128.130.175.61]:53531 "EHLO
	mail.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbaKGN51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 08:57:27 -0500
Date: Fri, 7 Nov 2014 22:57:23 +0900
From: Norbert Preining <preining@logic.at>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org
Subject: Re: khugepaged / firefox going wild in 3.18-rc
Message-ID: <20141107135723.GH11838@auth.logic.tuwien.ac.at>
References: <20141104232027.GO13232@auth.logic.tuwien.ac.at>
 <alpine.DEB.2.10.1411041559170.2720@chino.kir.corp.google.com>
 <20141105001026.GQ13232@auth.logic.tuwien.ac.at>
 <20141105001243.GR13232@auth.logic.tuwien.ac.at>
 <alpine.DEB.2.10.1411041615270.5391@chino.kir.corp.google.com>
 <545B68C9.2060107@suse.cz>
 <20141106123904.GU11838@auth.logic.tuwien.ac.at>
 <545B71A8.6030209@suse.cz>
 <20141107130717.GF11838@auth.logic.tuwien.ac.at>
 <545CCB49.2010405@suse.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="5QAgd0e35j3NYeGe"
Content-Disposition: inline
In-Reply-To: <545CCB49.2010405@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5QAgd0e35j3NYeGe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Vlastimil,

On Fri, 07 Nov 2014, Vlastimil Babka wrote:
> Great, that's good news if I understand correctly, but ...

no "but ..."

> I suggested the commit to you for revert 1 day ago, and you say you
> can't reproduce it for 2 days already? That's a bit suspicious. Did

No, you suggested it yesterday during the day, and here in Japan the 
next day is already over, so my feeling is two days ;-)

So all fine ;-)

> I'll prepare a debugging patch and send with instructions. Meanwhile
> you could send the /proc/zoneinfo contents? :)

When? Running which kernel? Anyway, with the current kernel (reverted
commit as before) I get the attached zoneinfo.

Thanks, and waiting for your patches ;-)

Norbert

------------------------------------------------------------------------
PREINING, Norbert                               http://www.preining.info
JAIST, Japan                                 TeX Live & Debian Developer
GPG: 0x860CDC13   fp: F7D8 A928 26E3 16A1 9FA0  ACF0 6CAC A448 860C DC13
------------------------------------------------------------------------

--5QAgd0e35j3NYeGe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="zoneinfo.txt"

Node 0, zone      DMA
  pages free     3974
        min      66
        low      82
        high     99
        scanned  0
        spanned  4095
        present  3996
        managed  3974
    nr_free_pages 3974
    nr_alloc_batch 17
    nr_inactive_anon 0
    nr_active_anon 0
    nr_inactive_file 0
    nr_active_file 0
    nr_unevictable 0
    nr_mlock     0
    nr_anon_pages 0
    nr_mapped    0
    nr_file_pages 0
    nr_dirty     0
    nr_writeback 0
    nr_slab_reclaimable 0
    nr_slab_unreclaimable 0
    nr_page_table_pages 0
    nr_kernel_stack 0
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 0
    nr_vmscan_immediate_reclaim 0
    nr_writeback_temp 0
    nr_isolated_anon 0
    nr_isolated_file 0
    nr_shmem     0
    nr_dirtied   0
    nr_written   0
    nr_pages_scanned 0
    workingset_refault 0
    workingset_activate 0
    workingset_nodereclaim 0
    nr_anon_transparent_hugepages 0
    nr_free_cma  0
        protection: (0, 3399, 7878, 7878)
  pagesets
    cpu: 0
              count: 0
              high:  0
              batch: 1
  vm stats threshold: 6
    cpu: 1
              count: 0
              high:  0
              batch: 1
  vm stats threshold: 6
    cpu: 2
              count: 0
              high:  0
              batch: 1
  vm stats threshold: 6
    cpu: 3
              count: 0
              high:  0
              batch: 1
  vm stats threshold: 6
  all_unreclaimable: 1
  start_pfn:         1
  inactive_ratio:    1
Node 0, zone    DMA32
  pages free     557017
        min      14552
        low      18190
        high     21828
        scanned  0
        spanned  1044480
        present  889801
        managed  871049
    nr_free_pages 557017
    nr_alloc_batch 3572
    nr_inactive_anon 12444
    nr_active_anon 67252
    nr_inactive_file 86719
    nr_active_file 125886
    nr_unevictable 4
    nr_mlock     4
    nr_anon_pages 67107
    nr_mapped    22262
    nr_file_pages 225198
    nr_dirty     20
    nr_writeback 0
    nr_slab_reclaimable 11794
    nr_slab_unreclaimable 5026
    nr_page_table_pages 2369
    nr_kernel_stack 226
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 0
    nr_vmscan_immediate_reclaim 0
    nr_writeback_temp 0
    nr_isolated_anon 0
    nr_isolated_file 0
    nr_shmem     12593
    nr_dirtied   224825
    nr_written   214052
    nr_pages_scanned 0
    workingset_refault 0
    workingset_activate 0
    workingset_nodereclaim 0
    nr_anon_transparent_hugepages 28
    nr_free_cma  0
        protection: (0, 0, 4478, 4478)
  pagesets
    cpu: 0
              count: 159
              high:  186
              batch: 31
  vm stats threshold: 36
    cpu: 1
              count: 145
              high:  186
              batch: 31
  vm stats threshold: 36
    cpu: 2
              count: 99
              high:  186
              batch: 31
  vm stats threshold: 36
    cpu: 3
              count: 65
              high:  186
              batch: 31
  vm stats threshold: 36
  all_unreclaimable: 0
  start_pfn:         4096
  inactive_ratio:    5
Node 0, zone   Normal
  pages free     712051
        min      19172
        low      23965
        high     28758
        scanned  0
        spanned  1179136
        present  1179136
        managed  1146604
    nr_free_pages 712051
    nr_alloc_batch 1771
    nr_inactive_anon 11186
    nr_active_anon 96996
    nr_inactive_file 113106
    nr_active_file 178825
    nr_unevictable 8
    nr_mlock     8
    nr_anon_pages 96917
    nr_mapped    31145
    nr_file_pages 303206
    nr_dirty     13
    nr_writeback 0
    nr_slab_reclaimable 13001
    nr_slab_unreclaimable 5053
    nr_page_table_pages 3211
    nr_kernel_stack 207
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 0
    nr_vmscan_immediate_reclaim 0
    nr_writeback_temp 0
    nr_isolated_anon 0
    nr_isolated_file 0
    nr_shmem     11275
    nr_dirtied   327684
    nr_written   314671
    nr_pages_scanned 0
    workingset_refault 0
    workingset_activate 0
    workingset_nodereclaim 0
    nr_anon_transparent_hugepages 45
    nr_free_cma  0
        protection: (0, 0, 0, 0)
  pagesets
    cpu: 0
              count: 170
              high:  186
              batch: 31
  vm stats threshold: 42
    cpu: 1
              count: 134
              high:  186
              batch: 31
  vm stats threshold: 42
    cpu: 2
              count: 136
              high:  186
              batch: 31
  vm stats threshold: 42
    cpu: 3
              count: 97
              high:  186
              batch: 31
  vm stats threshold: 42
  all_unreclaimable: 0
  start_pfn:         1048576
  inactive_ratio:    6

--5QAgd0e35j3NYeGe--
