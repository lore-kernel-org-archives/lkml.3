Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751238AbaLZQC0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 11:02:26 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:58958 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbaLZQCX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 11:02:23 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: "Stefan I. Strogin" <s.strogin@partner.samsung.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc: "Stefan I. Strogin" <s.strogin@partner.samsung.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        aneesh.kumar@linux.vnet.ibm.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Dmitry Safonov <d.safonov@partner.samsung.com>,
        Pintu Kumar <pintu.k@samsung.com>,
        Weijie Yang <weijie.yang@samsung.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        SeongJae Park <sj38.park@gmail.com>, Hui Zhu <zhuhui@xiaomi.com>,
        Minchan Kim <minchan@kernel.org>, Dyasly Sergey <s.dyasly@samsung.com>,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>
Subject: Re: [PATCH 2/3] mm: cma: introduce /proc/cmainfo
In-Reply-To: <264ce8ad192124f2afec9a71a2fc28779d453ba7.1419602920.git.s.strogin@partner.samsung.com>
Organization: http://mina86.com/
References: <cover.1419602920.git.s.strogin@partner.samsung.com> <264ce8ad192124f2afec9a71a2fc28779d453ba7.1419602920.git.s.strogin@partner.samsung.com>
User-Agent: Notmuch/0.19~rc1+1~g03aea4f (http://notmuchmail.org) Emacs/25.0.50.3 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:141226:lauraa@codeaurora.org::3XEwIFFS6dSOquvE:000000000000000000000000000000000000000003sI
X-Hashcash: 1:20:141226:weijie.yang@samsung.com::jL5v3Lt8OMQOV/FV:000000000000000000000000000000000000000JKq
X-Hashcash: 1:20:141226:pintu.k@samsung.com::ixT6n5phy5/lxi3E:0000000000000000000000000000000000000000000WUy
X-Hashcash: 1:20:141226:linux-mm@kvack.org::zawRNjvApQN+v9zZ:00000000000000000000000000000000000000000000Zyd
X-Hashcash: 1:20:141226:linux-kernel@vger.kernel.org::RT9rwYupoWiEJy9V:0000000000000000000000000000000000yUx
X-Hashcash: 1:20:141226:m.szyprowski@samsung.com::UV5+/+z42kIhYzrH:000000000000000000000000000000000000012S6
X-Hashcash: 1:20:141226:d.safonov@partner.samsung.com::KVH9avwXJL6HSccL:000000000000000000000000000000000uGw
X-Hashcash: 1:20:141226:zhuhui@xiaomi.com::BaGuJhQ6U8hWPRQo:000000000000000000000000000000000000000000000yVv
X-Hashcash: 1:20:141226:laurent.pinchart@ideasonboard.com::67LM+z1NYUPNsn5L:00000000000000000000000000001Ah0
X-Hashcash: 1:20:141226:akpm@linux-foundation.org::2BOQayFxwdM5mS+d:0000000000000000000000000000000000001FdN
X-Hashcash: 1:20:141226:s.strogin@partner.samsung.com::WpaqmnwGcB1oihze:000000000000000000000000000000001xXQ
X-Hashcash: 1:20:141226:sj38.park@gmail.com::TIcBeo4Ej10xe0to:0000000000000000000000000000000000000000001RRM
X-Hashcash: 1:20:141226:minchan@kernel.org::9luODSjQlraKnyhg:00000000000000000000000000000000000000000003un+
X-Hashcash: 1:20:141226:iamjoonsoo.kim@lge.com::Ym9EGGjvwU2/V4Tu:0000000000000000000000000000000000000003myI
X-Hashcash: 1:20:141226:s.strogin@partner.samsung.com::qWvrIlTmb96Ui78O:000000000000000000000000000000002xbs
X-Hashcash: 1:20:141226:aneesh.kumar@linux.vnet.ibm.com::4xMlB7V1670jBwSf:0000000000000000000000000000003Syr
X-Hashcash: 1:20:141226:v.tyrtov@samsung.com::X5sMKRWvVd9LWDVj:000000000000000000000000000000000000000004Vrh
X-Hashcash: 1:20:141226:s.dyasly@samsung.com::TyQj7LGhwLQRc6d3:00000000000000000000000000000000000000000GC/9
Date: Fri, 26 Dec 2014 17:02:18 +0100
Message-ID: <xa1tzjaaz9f9.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 26 2014, "Stefan I. Strogin" <s.strogin@partner.samsung.com> wrote:
> /proc/cmainfo contains a list of currently allocated CMA buffers for every
> CMA area when CONFIG_CMA_DEBUG is enabled.
>
> Format is:
>
> <base_phys_addr> - <end_phys_addr> (<size> kB), allocated by <PID>\
> 		(<command name>), latency <allocation latency> us
>  <stack backtrace when the buffer had been allocated>
>
> Signed-off-by: Stefan I. Strogin <s.strogin@partner.samsung.com>
> ---
>  mm/cma.c | 202 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 202 insertions(+)
>
> diff --git a/mm/cma.c b/mm/cma.c
> index a85ae28..ffaea26 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -34,6 +34,10 @@
>  #include <linux/cma.h>
>  #include <linux/highmem.h>
>  #include <linux/io.h>
> +#include <linux/list.h>
> +#include <linux/proc_fs.h>
> +#include <linux/uaccess.h>
> +#include <linux/time.h>
>  
>  struct cma {
>  	unsigned long	base_pfn;
> @@ -41,8 +45,25 @@ struct cma {
>  	unsigned long	*bitmap;
>  	unsigned int order_per_bit; /* Order of pages represented by one bit */
>  	struct mutex	lock;
> +#ifdef CONFIG_CMA_DEBUG
> +	struct list_head buffers_list;
> +	struct mutex	list_lock;
> +#endif
>  };
>  
> +#ifdef CONFIG_CMA_DEBUG
> +struct cma_buffer {
> +	unsigned long pfn;
> +	unsigned long count;
> +	pid_t pid;
> +	char comm[TASK_COMM_LEN];
> +	unsigned int latency;
> +	unsigned long trace_entries[16];
> +	unsigned int nr_entries;
> +	struct list_head list;
> +};
> +#endif
> +
>  static struct cma cma_areas[MAX_CMA_AREAS];
>  static unsigned cma_area_count;
>  static DEFINE_MUTEX(cma_mutex);
> @@ -132,6 +153,10 @@ static int __init cma_activate_area(struct cma *cma)
>  	} while (--i);
>  
>  	mutex_init(&cma->lock);
> +#ifdef CONFIG_CMA_DEBUG
> +	INIT_LIST_HEAD(&cma->buffers_list);
> +	mutex_init(&cma->list_lock);
> +#endif
>  	return 0;
>  
>  err:
> @@ -347,6 +372,86 @@ err:
>  	return ret;
>  }
>  
> +#ifdef CONFIG_CMA_DEBUG
> +/**
> + * cma_buffer_list_add() - add a new entry to a list of allocated buffers
> + * @cma:     Contiguous memory region for which the allocation is performed.
> + * @pfn:     Base PFN of the allocated buffer.
> + * @count:   Number of allocated pages.
> + * @latency: Nanoseconds spent to allocate the buffer.
> + *
> + * This function adds a new entry to the list of allocated contiguous memory
> + * buffers in a CMA area. It uses the CMA area specificated by the device
> + * if available or the default global one otherwise.
> + */
> +static int cma_buffer_list_add(struct cma *cma, unsigned long pfn,
> +			       int count, s64 latency)
> +{
> +	struct cma_buffer *cmabuf;
> +	struct stack_trace trace;
> +
> +	cmabuf = kmalloc(sizeof(struct cma_buffer), GFP_KERNEL);

	cmabuf = kmalloc(sizeof *cmabuf, GFP_KERNEL);

> +	if (!cmabuf)
> +		return -ENOMEM;
> +
> +	trace.nr_entries = 0;
> +	trace.max_entries = ARRAY_SIZE(cmabuf->trace_entries);
> +	trace.entries = &cmabuf->trace_entries[0];
> +	trace.skip = 2;
> +	save_stack_trace(&trace);
> +
> +	cmabuf->pfn = pfn;
> +	cmabuf->count = count;
> +	cmabuf->pid = task_pid_nr(current);
> +	cmabuf->nr_entries = trace.nr_entries;
> +	get_task_comm(cmabuf->comm, current);
> +	cmabuf->latency = (unsigned int) div_s64(latency, NSEC_PER_USEC);
> +
> +	mutex_lock(&cma->list_lock);
> +	list_add_tail(&cmabuf->list, &cma->buffers_list);
> +	mutex_unlock(&cma->list_lock);
> +
> +	return 0;
> +}
> +
> +/**
> + * cma_buffer_list_del() - delete an entry from a list of allocated buffers
> + * @cma:   Contiguous memory region for which the allocation was performed.
> + * @pfn:   Base PFN of the released buffer.
> + *
> + * This function deletes a list entry added by cma_buffer_list_add().
> + */
> +static void cma_buffer_list_del(struct cma *cma, unsigned long pfn)
> +{
> +	struct cma_buffer *cmabuf;
> +
> +	mutex_lock(&cma->list_lock);
> +
> +	list_for_each_entry(cmabuf, &cma->buffers_list, list)
> +		if (cmabuf->pfn == pfn) {
> +			list_del(&cmabuf->list);
> +			kfree(cmabuf);
> +			goto out;
> +		}

You do not have guarantee that CMA deallocations will match allocations
exactly.  User may allocate CMA region and then free it chunks.  I'm not
saying that the debug code must handle than case but at least I would
like to see a comment describing this shortcoming.

> +
> +	pr_err("%s(pfn %lu): couldn't find buffers list entry\n",
> +	       __func__, pfn);
> +
> +out:
> +	mutex_unlock(&cma->list_lock);
> +}
> +#else
> +static int cma_buffer_list_add(struct cma *cma, unsigned long pfn,
> +			       int count, s64 latency)
> +{
> +	return 0;
> +}
> +
> +static void cma_buffer_list_del(struct cma *cma, unsigned long pfn)
> +{
> +}
> +#endif /* CONFIG_CMA_DEBUG */
> +
>  /**
>   * cma_alloc() - allocate pages from contiguous area
>   * @cma:   Contiguous memory region for which the allocation is performed.
> @@ -361,11 +466,15 @@ struct page *cma_alloc(struct cma *cma, int count, unsigned int align)
>  	unsigned long mask, offset, pfn, start = 0;
>  	unsigned long bitmap_maxno, bitmap_no, bitmap_count;
>  	struct page *page = NULL;
> +	struct timespec ts1, ts2;
> +	s64 latency;
>  	int ret;
>  
>  	if (!cma || !cma->count)
>  		return NULL;
>  
> +	getnstimeofday(&ts1);
> +

If CMA_DEBUG is disabled, you waste time on measuring latency.  Either
use #ifdef or IS_ENABLED, e.g.:

	if (IS_ENABLED(CMA_DEBUG))
		getnstimeofday(&ts1);

>  	pr_debug("%s(cma %p, count %d, align %d)\n", __func__, (void *)cma,
>  		 count, align);
>  
> @@ -413,6 +522,19 @@ struct page *cma_alloc(struct cma *cma, int count, unsigned int align)
>  		start = bitmap_no + mask + 1;
>  	}
>  
> +	getnstimeofday(&ts2);
> +	latency = timespec_to_ns(&ts2) - timespec_to_ns(&ts1);
> +
> +	if (page) {

	if (IS_ENABLED(CMA_DEBUG) && page) {
		getnstimeofday(&ts2);
		latency = timespec_to_ns(&ts2) - timespec_to_ns(&ts1);

> +		ret = cma_buffer_list_add(cma, pfn, count, latency);

You could also change cma_buffer_list_add to take ts1 as an argument
instead of latency and then latency calculating would be hidden inside
of that function.  Initialising ts1 should still be guarded with
IS_ENABLED of course.

> +		if (ret) {
> +			pr_warn("%s(): cma_buffer_list_add() returned %d\n",
> +				__func__, ret);
> +			cma_release(cma, page, count);
> +			page = NULL;

Harsh, but ok, if you want.

> +		}
> +	}
> +
>  	pr_debug("%s(): returned %p\n", __func__, page);
>  	return page;
>  }
> @@ -445,6 +567,86 @@ bool cma_release(struct cma *cma, struct page *pages, int count)
>  
>  	free_contig_range(pfn, count);
>  	cma_clear_bitmap(cma, pfn, count);
> +	cma_buffer_list_del(cma, pfn);
>  
>  	return true;
>  }
> +
> +#ifdef CONFIG_CMA_DEBUG
> +static void *s_start(struct seq_file *m, loff_t *pos)
> +{
> +	struct cma *cma = 0;
> +
> +	if (*pos == 0 && cma_area_count > 0)
> +		cma = &cma_areas[0];
> +	else
> +		*pos = 0;
> +
> +	return cma;
> +}
> +
> +static int s_show(struct seq_file *m, void *p)
> +{
> +	struct cma *cma = p;
> +	struct cma_buffer *cmabuf;
> +	struct stack_trace trace;
> +
> +	mutex_lock(&cma->list_lock);
> +
> +	list_for_each_entry(cmabuf, &cma->buffers_list, list) {
> +		seq_printf(m, "0x%llx - 0x%llx (%lu kB), allocated by pid %u (%s), latency %u us\n",
> +			   (unsigned long long)PFN_PHYS(cmabuf->pfn),
> +			   (unsigned long long)PFN_PHYS(cmabuf->pfn +
> +							cmabuf->count),
> +			   (cmabuf->count * PAGE_SIZE) >> 10, cmabuf->pid,
> +			   cmabuf->comm, cmabuf->latency);
> +
> +		trace.nr_entries = cmabuf->nr_entries;
> +		trace.entries = &cmabuf->trace_entries[0];
> +
> +		seq_print_stack_trace(m, &trace, 0);
> +		seq_putc(m, '\n');
> +	}
> +
> +	mutex_unlock(&cma->list_lock);
> +	return 0;
> +}
> +
> +static void *s_next(struct seq_file *m, void *p, loff_t *pos)
> +{
> +	struct cma *cma = (struct cma *)p + 1;
> +
> +	return (cma < &cma_areas[cma_area_count]) ? cma : 0;
> +}
> +
> +static void s_stop(struct seq_file *m, void *p)
> +{
> +}
> +
> +static const struct seq_operations cmainfo_op = {
> +	.start = s_start,
> +	.show = s_show,
> +	.next = s_next,
> +	.stop = s_stop,
> +};
> +
> +static int cmainfo_open(struct inode *inode, struct file *file)
> +{
> +	return seq_open(file, &cmainfo_op);
> +}
> +
> +static const struct file_operations proc_cmainfo_operations = {
> +	.open = cmainfo_open,
> +	.read = seq_read,
> +	.llseek = seq_lseek,
> +	.release = seq_release_private,
> +};
> +
> +static int __init proc_cmainfo_init(void)
> +{
> +	proc_create("cmainfo", S_IRUSR, NULL, &proc_cmainfo_operations);
> +	return 0;
> +}
> +
> +module_init(proc_cmainfo_init);
> +#endif /* CONFIG_CMA_DEBUG */
> -- 
> 2.1.0
>

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
